# Example Blue Print App 📱

This is a fully functioning Flutter application built strictly following the **Antigravity Flutter Blueprint**. It serves as a living, breathing reference implementation of senior-level Flutter architecture.

## 🌟 What This App Does

This application is a simple e-commerce showcase consuming the public `fakestoreapi.com`. 
It features a full end-to-end flow demonstrating:
1. **Product List Page**: Fetches and displays a list of products using `Dio`.
2. **Pull-to-Refresh**: Demonstrates `bloc_concurrency` (`restartable()`) to cancel stale API requests.
3. **Error Handling & Retries**: Uses `dio_smart_retry` and a custom UI error widget to allow users to retry failed requests.
4. **Product Detail Page**: Demonstrates passing IDs via `go_router` deep links and fetching single items.

## 🏗️ Architecture Under the Hood

Even though the app is simple, it is built with enterprise-grade infrastructure:
- **Feature-First**: Look at `lib/pages/product_list/` to see how the Bloc, Models, Repositories, and Widgets are grouped by feature.
- **State Management**: Uses a single `ProductListState` class with `BlocStatus` enum instead of Freezed/Sealed classes.
- **Race-Condition Safe Tokens**: Look at `lib/core/network/auth_interceptor.dart` to see a `Completer` queue implementation that prevents 5 simultaneous 401 errors from triggering 5 token refreshes.
- **Safe Networking**: Repositories wrap all `Dio` calls in `fpdart`'s `Either<Failure, SuccessData>` so the BLoC never crashes from raw exceptions.
- **Pixel-Perfect UI**: Uses `flutter_screenutil` (e.g. `16.w`, `24.h`) to scale perfectly across devices while being locked to portrait mode.

## 🚀 How to Run the App

This app uses **Flavors** (Dev, Staging, Prod) and secure compile-time environment variables. 
**You cannot just press Play.** You must pass the env config file.

### 1. Generate Files
If you haven't already, run `build_runner` to generate the JSON serialization models:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. Create the Env Files
At the root of the project (`example_blue_print_app/`), create `env_dev.json`:
```json
{
  "API_URL": "https://fakestoreapi.com",
  "API_KEY": "dev_key_123"
}
```

### 3. Run with Flavors
```bash
# Run Development Flavor
flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=env_dev.json

# Run Staging Flavor
flutter run --flavor staging -t lib/main_staging.dart --dart-define-from-file=env_staging.json

# Run Production Flavor
flutter run --flavor prod -t lib/main_prod.dart --dart-define-from-file=env_prod.json
```

## 🧪 Testing

This app implements a strict 3-tier testing strategy. Look inside the `test/` folder to see how it's done:

1. **Repository Unit Tests**: Mocks the `Dio` instance to test JSON parsing and `Either` wrapping.
2. **BLoC Unit Tests**: Uses `bloc_test` and `mocktail` to verify event-to-state emissions.
3. **Widget Tests**: Uses `MockBloc` to force the UI into specific states without hitting the network.
4. **Integration Tests**: Look in `integration_test/app_test.dart` for the end-to-end full-app test using `pumpAndSettle()`.

```bash
# Run unit & widget tests
flutter test

# Run integration tests
flutter test integration_test/app_test.dart
```
