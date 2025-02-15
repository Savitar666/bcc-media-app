import 'package:auto_route/auto_route.dart';
import 'package:brunstadtv_app/helpers/extensions.dart';
import 'package:brunstadtv_app/providers/analytics.dart';
import 'package:brunstadtv_app/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/constants.dart';

class AnalyticsNavigatorObserver extends NavigatorObserver {
  bool _routeFilter(Route<dynamic> route) {
    final routeData = route.settings.asOrNull<AutoRoutePage>()?.routeData;
    if (routeData == null) return true;
    if (routeData.meta[RouteMetaConstants.navTabRoute] != null && routeData.meta[RouteMetaConstants.navTabRoute]) {
      return false;
    }
    return true;
  }

  void _sendScreenView(Route<dynamic> route) {
    final context = navigator?.context;
    if (context == null) {
      return;
    }
    final ref = ProviderScope.containerOf(context, listen: false);
    Map<String, dynamic> extraProperties = {};
    extraProperties['meta'] = <String, dynamic>{};
    final routeData = route.settings.asOrNull<AutoRoutePage>()?.routeData;
    if (routeData == null) return;

    String? screenName = routeData.meta[RouteMetaConstants.analyticsName];
    final pageRouteArgs = routeData.args.asOrNull<PageScreenRouteArgs>();
    if (pageRouteArgs != null) {
      screenName = pageRouteArgs.pageCode;
      extraProperties['pageCode'] = pageRouteArgs.pageCode;
    }
    final episodeRouteArgs = routeData.args.asOrNull<EpisodeScreenRouteArgs>();
    if (episodeRouteArgs != null) {
      extraProperties['meta']['episodeId'] = episodeRouteArgs.episodeId;
    }

    if (routeData.meta.containsKey(RouteMetaConstants.settingsName)) {
      extraProperties['meta']['settings'] = routeData.meta[RouteMetaConstants.settingsName];
    }

    screenName ??= routeData.path;

    if (screenName.isNotEmpty) {
      SchedulerBinding.instance.scheduleFrameCallback((_) => ref.read(analyticsProvider).screen(screenName!, properties: extraProperties));
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('didPush ${route.settings.name}');
    super.didPush(route, previousRoute);
    if (_routeFilter(route)) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    debugPrint('didReplace ${newRoute?.settings.name}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && _routeFilter(newRoute)) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('didPop ${route.settings.name}');
    super.didPop(route, previousRoute);
    if (previousRoute != null && _routeFilter(previousRoute) && _routeFilter(route)) {
      _sendScreenView(previousRoute);
    }
  }
}
