import 'package:auto_route/auto_route.dart';
import 'package:my_app/router/auth_guard.dart';
import 'package:my_app/screens/app_language.dart';
import 'package:my_app/screens/home.dart';
import 'package:my_app/screens/live.dart';
import 'package:my_app/screens/login.dart';
import 'package:my_app/screens/profile/profile.dart';
import 'package:my_app/screens/search/search.dart';

import '../screens/episode.dart';
import '../screens/root.dart';
import '../screens/search/explore_category_page.dart';

@MaterialAutoRouter(
  routes: [
    MaterialRoute<void>(page: LoginScreen, path: '/login'),
    MaterialRoute<void>(page: Profile, path: 'profile'),
    MaterialRoute<void>(page: AppLanguageScreen, path: 'app-language'),
    CustomRoute<void>(
        page: EpisodeScreen,
        path: 'episode/:episodeId',
        transitionsBuilder: TransitionsBuilders.zoomIn,
        durationInMilliseconds: 200),
    MaterialRoute<void>(page: RootScreen, path: '/', initial: true, guards: [
      AuthGuard
    ], children: [
      MaterialRoute<void>(page: HomeScreen, path: 'home'),
      MaterialRoute<void>(page: LiveScreen, path: 'live'),
      MaterialRoute<void>(
          page: EmptyRouterPage,
          path: 'search',
          initial: true,
          children: [
            MaterialRoute<void>(page: SearchScreen, path: ''),
            MaterialRoute<void>(
                page: ExploreCategoryScreen, path: 'explore-category'),
          ]),
    ]),
  ],
)
class $AppRouter {}
