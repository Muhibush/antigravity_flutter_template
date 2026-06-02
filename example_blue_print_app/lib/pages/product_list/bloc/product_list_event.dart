import 'package:equatable/equatable.dart';

/// Events for the Product List BLoC.
///
/// Blueprint Rule: Name events as actions that happened in the past,
/// using the format `Subject + Noun + PastTenseVerb`.
/// DO NOT use command-style names like `FetchProducts`.
sealed class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the product list page is first opened
/// and products need to be loaded.
final class ProductListFetchRequested extends ProductListEvent {
  const ProductListFetchRequested();
}

/// Fired when the user pulls to refresh the product list.
final class ProductListRefreshRequested extends ProductListEvent {
  const ProductListRefreshRequested();
}
