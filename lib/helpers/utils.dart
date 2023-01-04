import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:brunstadtv_app/graphql/client.dart';
import 'package:brunstadtv_app/graphql/queries/episode.graphql.dart';
import 'package:brunstadtv_app/providers/analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../graphql/queries/page.graphql.dart';
import '../router/router.gr.dart';
import 'navigation_override.dart';

T? cast<T>(x) => x is T ? x : null;

extension AsExtension on Object? {
  X as<X>() => this as X;
  X? asOrNull<X>() {
    var self = this;
    return self is X ? self : null;
  }
}

extension FiniteOrNull on double {
  double? finiteOrNull() {
    return isFinite ? this : null;
  }
}

String formatAppVersion(PackageInfo packageInfo) {
  return '${packageInfo.version}+${packageInfo.buildNumber}';
}

String getFormattedAgeRating(String ageRating) {
  return ageRating == 'A' ? '0+' : '$ageRating+';
}

FutureBuilder simpleFutureBuilder<T>(
    {required Future<T>? future,
    required Widget Function() loading,
    required Widget Function(Object?) error,
    required Widget Function() noData,
    required Widget Function(T) ready}) {
  return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loading();
        }
        if (snapshot.hasError) {
          return error(snapshot.error);
        }
        final data = snapshot.data;
        if (data != null) {
          return ready(data);
        } else {
          return noData();
        }
      });
}

Future overrideAwareNavigation(NavigationOverride? override, StackRouter router, PageRouteInfo<dynamic> route) {
  if (override?.pushInsteadOfReplace == true) {
    return router.push(route);
  } else {
    return router.navigate(route);
  }
}

Future<dynamic>? handleSectionItemClick(BuildContext context, Fragment$ItemSectionItem$item item) {
  final ref = ProviderScope.containerOf(context, listen: false);
  final analytics = ref.read(analyticsProvider);
  analytics.sectionItemClicked(context);

  final navigationOverride = NavigationOverride.of(context);
  final router = context.router;
  var episodeItem = item.asOrNull<Fragment$ItemSectionItem$item$$Episode>();
  if (episodeItem != null) {
    return overrideAwareNavigation(navigationOverride, router, EpisodeScreenRoute(episodeId: episodeItem.id));
  }

  var showItem = item.asOrNull<Fragment$ItemSectionItem$item$$Show>();
  if (showItem != null) {
    return overrideAwareNavigation(navigationOverride, router, EpisodeScreenRoute(episodeId: showItem.defaultEpisode.id));
  }

  var pageItem = item.asOrNull<Fragment$ItemSectionItem$item$$Page>();
  if (pageItem != null) {
    return overrideAwareNavigation(navigationOverride, router, PageScreenRoute(pageCode: pageItem.code));
  }

  var linkItem = item.asOrNull<Fragment$ItemSectionItem$item$$Link>();
  if (linkItem != null) {
    return launchUrlString(linkItem.url, mode: LaunchMode.externalApplication);
  }

  return null;
}

Completer<T> wrapInCompleter<T>(Future<T> future) {
  final completer = Completer<T>();
  future.then(completer.complete).catchError(completer.completeError);
  return completer;
}

class ConditionalParentWidget extends StatelessWidget {
  const ConditionalParentWidget({
    super.key,
    required this.condition,
    required this.child,
    required this.conditionalBuilder,
  });

  final Widget child;
  final bool condition;
  final Widget Function(Widget child) conditionalBuilder;

  @override
  Widget build(BuildContext context) {
    return condition ? conditionalBuilder(child) : child;
  }
}
