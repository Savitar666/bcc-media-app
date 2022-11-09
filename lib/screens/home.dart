import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:brunstadtv_app/components/sign_in_tooltip.dart';
import 'package:brunstadtv_app/helpers/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brunstadtv_app/router/router.gr.dart';

import 'package:bccm_player/cast_button.dart';
import 'package:flutter_svg/svg.dart';
import '../helpers/btv_colors.dart';
import '../components/page.dart';
import '../graphql/client.dart';
import '../graphql/queries/page.graphql.dart';
import '../services/auth_service.dart';

final logo = Image.asset('assets/images/logo.png');

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<Query$Page$page> resultFuture;
  bool isGuestUser = false;
  bool showTooltip = false;
  GlobalKey profileIconKey = GlobalKey();
  Offset? tooltipPos;

  @override
  void initState() {
    super.initState();
    if (AuthService.instance.guestUser) {
      isGuestUser = true;
      showTooltip = true;
    }
    resultFuture = getPage();
  }

  void calcTooltipPos() {
    if (profileIconKey.currentContext == null) {
      return;
    }
    final RenderBox renderBox =
        profileIconKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final profileIconBottomCenterX = position.dx + renderBox.size.width / 2;
    final profileIconBottomCenterY = position.dy + renderBox.size.height;
    final newToolTipPos =
        Offset(profileIconBottomCenterX - 20, profileIconBottomCenterY);
    if (tooltipPos != newToolTipPos) {
      setState(() => tooltipPos = newToolTipPos);
    }
  }

  Future<Query$Page$page> getPage() async {
    final client = ref.read(gqlClientProvider);
    return client
        .query$Page(
      Options$Query$Page(variables: Variables$Query$Page(code: 'frontpage')),
    )
        .then(
      (value) {
        if (value.hasException) {
          throw ErrorDescription(value.exception.toString());
        }
        if (value.parsedData == null) {
          throw ErrorDescription("No data for page code: 'frontpage'");
        }
        return value.parsedData!.page;
      },
    ).catchError(
      (error) {
        print(error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      calcTooltipPos();
    });
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: 44,
            shadowColor: Colors.black,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: logo,
            leading: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (!isGuestUser) {
                      context.router.push(const ProfileRoute());
                    } else {
                      context.router.push(LoginScreenRoute());
                    }
                  },
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 18, top: 12, bottom: 12),
                      child: SvgPicture.string(
                        key: profileIconKey,
                        SvgIcons.profile,
                      ))),
            ),
            actions: const [SizedBox(width: 40, child: CastButton())],
            flexibleSpace: Container(
              decoration: const BoxDecoration(boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 8,
                    blurStyle: BlurStyle.outer)
              ]),
              child: ClipRect(
                clipBehavior: Clip.hardEdge,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          BtvColors.background1,
                          Colors.transparent
                        ])),
                    height: 1000,
                  ),
                ),
              ),
            ),
          ),
          body: BccmPage(
              pageFuture: resultFuture,
              onRefresh: () async {
                setState(() {
                  resultFuture = getPage();
                });
              }),
        ),
        if (showTooltip && tooltipPos != null)
          Positioned(
            left: tooltipPos!.dx,
            top: tooltipPos!.dy,
            child: SignInTooltip(onClose: () {
              setState(() => showTooltip = false);
            }),
          )
      ],
    );
  }
}
