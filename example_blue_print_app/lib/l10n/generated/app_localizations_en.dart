// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BlueprintApp';

  @override
  String get productsTitle => 'Products';

  @override
  String get productDetailTitle => 'Product Detail';

  @override
  String get descriptionLabel => 'Description';

  @override
  String reviewsCount(int count) {
    return '$count reviews';
  }

  @override
  String get retryButton => 'Retry';

  @override
  String get noInternetMessage =>
      'No internet connection. Please check your network.';

  @override
  String get genericErrorMessage => 'Something went wrong. Please try again.';
}
