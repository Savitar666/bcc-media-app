import 'package:brunstadtv_app/components/misc/collapsable_markdown.dart';
import 'package:brunstadtv_app/l10n/app_localizations.dart';
import 'package:brunstadtv_app/theme/design_system/bccmedia/design_system.dart';
import 'package:brunstadtv_app/theme/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/basic_init.dart';

const tests = [
  '''Testa

> teest

Check out [this awesome website!](https://bcc.media)''',
  '''> Some quote

Some other text
''',
  '''Text 1

Text 2

Some very long description that should be collapsed''',
  '''Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text''',
  '''Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text
  
  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text
  
  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text''',
  '''With *markdown*, Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text
  
  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text
  
  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text  Some very long simple plain text'''
];

void main() {
  testWidgets('Collapsible markdown test', (t) async {
    basicInit();
    for (final test in tests) {
      await testHeight(test, t);
    }
  });
}

Future<void> testHeight(String content, WidgetTester t) async {
  final key = GlobalKey();

  await t.pumpWidget(DesignSystem(
    designSystem: BccMediaDesignSystem(),
    child: (context) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: S.localizationsDelegates,
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CollapsableMarkdown(key: key, text: content, maxLines: 2),
          ],
        ),
      ),
    ),
  ));

  await t.pumpAndSettle();

  expect(find.byKey(key), findsOneWidget);

  // check widget width and height
  final size = t.getSize(find.byKey(key));
  expect(
    size.height,
    lessThanOrEqualTo(60),
    reason: content,
  );
}
