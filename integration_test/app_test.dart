import 'package:antigravity_app/app.dart';
import 'package:antigravity_app/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Integration test: Full end-to-end flow.
///
/// Run with:
/// ```bash
/// flutter test integration_test/app_test.dart
/// ```
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end: Product List → Product Detail', () {
    testWidgets(
      'loads products, taps first product, '
      'navigates to detail page',
      (tester) async {
        // 1. Set up the flavor (simulates main_dev.dart)
        F.appFlavor = Flavor.dev;

        // 2. Launch the full app
        await tester.pumpWidget(const App());

        // 3. Wait for network request to complete
        // (pumps frames until no more pending timers)
        await tester.pumpAndSettle(
          const Duration(seconds: 5),
        );

        // 4. Verify product list is displayed
        expect(
          find.byType(ListView),
          findsOneWidget,
        );

        // 5. Tap the first product card
        final firstCard = find.byType(InkWell).first;
        await tester.tap(firstCard);
        await tester.pumpAndSettle(
          const Duration(seconds: 3),
        );

        // 6. Verify we navigated to the detail page
        // (the AppBar should show a back button)
        expect(
          find.byType(BackButton),
          findsOneWidget,
        );
      },
    );
  });
}
