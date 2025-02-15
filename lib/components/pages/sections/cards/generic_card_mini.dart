import 'package:brunstadtv_app/components/thumbnails/misc/bordered_image_container.dart';
import 'package:brunstadtv_app/components/misc/shiny_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../theme/design_system/design_system.dart';
import '../../../../helpers/svg_icons.dart';
import '../../../../graphql/queries/page.graphql.dart';
import '../../../../helpers/router/router_utils.dart';
import '../../../../helpers/misc.dart';
import '../../../status/loading_indicator.dart';

class GenericCardMini extends StatefulWidget {
  final Fragment$Section$$CardSection$items$items item;
  const GenericCardMini({super.key, required this.item});

  @override
  State<GenericCardMini> createState() => _GenericCardMiniState();
}

class _GenericCardMiniState extends State<GenericCardMini> {
  Future? navigationFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);
    return GestureDetector(
      onTap: () => setState(() {
        navigationFuture = handleSectionItemClick(context, widget.item.item);
      }),
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: design.colors.tint1.withAlpha((255 * 0.1).round()),
            ),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: design.colors.separatorOnLight, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: BorderedImageContainer(
                        borderRadius: BorderRadius.circular(12),
                        imageUrl: widget.item.image,
                      ),
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          widget.item.title,
                          style: design.textStyles.title3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          widget.item.description,
                          style: design.textStyles.body2.copyWith(color: design.colors.label3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SvgPicture.string(
                    SvgIcons.chevronRight,
                    color: design.colors.label3,
                    width: 9,
                    height: 17,
                  ),
                )
              ],
            ),
          ),
          Positioned.fill(
            child: LayoutBuilder(builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.only(left: constraints.maxWidth * 0.6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ClipPath(
                    clipper: ShinyClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xffccddff), Color(0xffedf2fd), Color(0x00ccddff)],
                        ).scale(0.1),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          if (navigationFuture != null)
            simpleFutureBuilder(
                future: navigationFuture!,
                loading: () => Positioned.fill(
                    child: Container(color: design.colors.background1.withOpacity(0.5), child: const Center(child: LoadingIndicator()))),
                error: (e) => const SizedBox.shrink(),
                noData: () => const SizedBox.shrink(),
                ready: (d) => const SizedBox.shrink()),
        ],
      ),
    );
  }
}
