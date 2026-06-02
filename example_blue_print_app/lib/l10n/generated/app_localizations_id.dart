// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'BlueprintApp';

  @override
  String get productsTitle => 'Produk';

  @override
  String get productDetailTitle => 'Detail Produk';

  @override
  String get descriptionLabel => 'Deskripsi';

  @override
  String reviewsCount(int count) {
    return '$count ulasan';
  }

  @override
  String get retryButton => 'Coba Lagi';

  @override
  String get noInternetMessage =>
      'Tidak ada koneksi internet. Silakan periksa jaringan Anda.';

  @override
  String get genericErrorMessage => 'Terjadi kesalahan. Silakan coba lagi.';
}
