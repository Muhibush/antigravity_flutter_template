import 'package:example_blue_print_app/core/routing/app_router.dart';
import 'package:example_blue_print_app/core/theme/app_theme.dart';
import 'package:example_blue_print_app/flavors.dart';
import 'package:example_blue_print_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The root application widget shared across all flavors.
///
/// Configures:
/// - `ScreenUtilInit` for responsive `.w`, `.h`, `.r`, `.sp` units.
/// - `GoRouter` for declarative routing.
/// - `AppTheme` for the design system.
/// - `AppLocalizations` for i18n.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: F.title,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          routerConfig: AppRouter.router,

          // ── Localization ──
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
