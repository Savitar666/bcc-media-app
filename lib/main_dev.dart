import 'package:brunstadtv_app/env/dev/firebase_options.dart' as dev_firebase;
import 'package:brunstadtv_app/flavors.dart';
import 'package:brunstadtv_app/main.dart';
import 'package:brunstadtv_app/theme/design_system/bccmedia/design_system.dart';
import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

void main() async {
  FlavorConfig.register(
    FlavorConfig(
      applicationCode: 'btv',
      flavor: Flavor.bccmedia,
      firebaseOptions: dev_firebase.DefaultFirebaseOptions.currentPlatform,
      enableNotifications: true,
      defaultLanguage: 'no',
      designSystem: () => BccMediaDesignSystem(),
      strings: (context) => FlavorStrings(
        onboardingTitle: S.of(context).loginPageDisplay1,
        onboardingSecondaryTitle: S.of(context).loginPageDisplay2,
        aboutText: S.of(context).bccMediaCenter,
        contactEmail: 'support@bcc.media',
        contactWebsite: Uri.parse('https://bcc.media'),
      ),
      bccmImages: BccmFlavorImages(
        logoHeight: 20,
        logo: const AssetImage('assets/flavors/prod/logo.png'),
        onboarding: const AssetImage('assets/flavors/prod/onboarding.png'),
        home: StateImageProvider(
          image: const AssetImage('assets/icons/Home_Default.png'),
          activeImage: const AssetImage('assets/icons/Home_Selected.png'),
        ),
        search: StateImageProvider(
          image: const AssetImage('assets/icons/Search_Default.png'),
          activeImage: const AssetImage('assets/icons/Search_Selected.png'),
        ),
        live: StateImageProvider(
          image: const AssetImage('assets/icons/Live_Default.png'),
          activeImage: const AssetImage('assets/icons/Live_Selected.png'),
        ),
        calendar: StateImageProvider(
          image: const AssetImage('assets/icons/Calendar_Default.png'),
          activeImage: const AssetImage('assets/icons/Calendar_Selected.png'),
        ),
        myList: StateImageProvider(
          image: const AssetImage('assets/icons/My_List_Default.png'),
          activeImage: const AssetImage('assets/icons/My_List_Selected.png'),
        ),
        games: StateImageProvider(
          image: const AssetImage('assets/icons/Games_Default.png'),
          activeImage: const AssetImage('assets/icons/Games_Selected.png'),
        ),
        profile: StateImageProvider(
          image: const AssetImage('assets/icons/Profile_Default.png'),
          activeImage: const AssetImage('assets/icons/Profile_Selected.png'),
        ),
      ),
    ),
  );
  return $main();
}
