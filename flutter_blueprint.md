# Senior Flutter Developer Blueprint

This Knowledge Item acts as the absolute source of truth for creating any new Flutter feature or application. It defines a robust, scalable architecture for senior-level development.

## 1. Project Structure (Feature-First)
All features are treated as "Pages".
Inside `lib/pages/feature_name/`, you MUST create the following structure:
*   `bloc/` - Contains the Bloc, State, and Event classes.
*   `model/` - Contains the data models (request/response).
*   `repository/` - Contains the data fetching logic.
*   `widget/` - Contains all UI components specific to this feature.
*   `feature_name_page.dart` - The main entry point for the page.

If a widget is highly complex (e.g., a massive BottomSheet), it should become its own nested feature folder inside `widget/` with its own `bloc/` and `widget/` folders.

### Core & Infrastructure (`lib/core/`)
Instead of dumping everything into a generic `utils/` folder, separate your infrastructure from your pure utilities:
*   `lib/core/network/` - Contains the `ApiProvider`, Interceptors, and Dio setup.
*   `lib/core/theme/` - Contains the Design System, Colors, Typography, and AppTheme.
    *   **CRITICAL:** Always consume colors and typography via `Theme.of(context).colorScheme` and `Theme.of(context).textTheme`. **DO NOT** directly import and use `AppColors` or `AppTypography` in your widgets, as it breaks dark mode and dynamic theming.
*   `lib/core/services/` - Third-party wrappers (Firebase, Analytics, Crashlytics, Local Storage/SharedPrefs).
*   `lib/core/routing/` - GoRouter setup and Route Constants.

### Pure Utilities (`lib/utils/`)
The `utils/` folder should be strictly reserved for pure functions and extensions that have no dependencies:
*   `lib/utils/extensions/` - `string_extension.dart`, `num_extension.dart`, `iterable_extension.dart`.
*   `lib/utils/formatters/` - Custom TextInputFormatters (e.g., `no_leading_zero_formatter.dart`).
*   `lib/utils/constants/` - Global enums and string constants. **DO NOT** hardcode keys like `'access_token'` across the codebase. Centralize them here (e.g. `StorageConstants`).

### Global & Shared Components (`lib/shared/`)
Do not clutter the top level with `lib/widget/` or `lib/model/`. Any component that is used across multiple features must be placed in the `shared/` directory:
*   `lib/shared/widgets/` - Reusable UI components (e.g., `CustomButton`, `LoadingOverlay`).
*   `lib/shared/models/` - Data models used by multiple features (e.g., `UserModel`, `PaginationInfo`).
*   `lib/shared/blocs/` - Global state managers (e.g., `AuthBloc`, `ThemeBloc`).
*   `lib/shared/repositories/` - Repositories accessed globally (e.g., `UserRepository`).

## 2. State Management (BLoC)
*   **State Shape:** **DO NOT** use sealed classes or Freezed for state matching. **DO** use a single State class with an `enum` for status (e.g., `enum BlocStatus { initial, loading, success, failure }`) and a `copyWith` method. This allows you to retain data (like a list of items) while showing a loading spinner, which is the official `bloclibrary.dev` recommendation for complex apps.
*   **Immutability (Lists):** **DO NOT** modify lists in place (e.g., `state.items.add(newItem)`). Equatable will ignore this. **DO** use the spread operator to create a new list instance (e.g., `emit(state.copyWith(items: [...state.items, newItem]));`).
*   **Event Naming:** **DO** name events exactly as actions that happened in the past, using the format `Subject + Noun + PastTenseVerb` (e.g., `LoginButtonPressed`, `ProductsFetchRequested`). **DO NOT** use command-style names (like `FetchProducts`).
*   **Business Logic:** Keep UI out of Blocs. Blocs should only receive events, call the Repository, and emit a new state using `copyWith`.
*   **Render Optimization:** **DO** use `Builder` + `context.select` as the single, consistent pattern for all state listening — including page-level layout switching and granular UI updates. **DO NOT** use `BlocBuilder` or `BlocSelector`. Use `context.read` only for fire-and-forget actions (e.g., dispatching events from a button tap).
*   **Side Effects:** **DO** use `BlocListener` for one-off side effects like navigation, showing dialogs, snackbars, or bottom sheets when the state changes. Never put navigation logic inside the BLoC class itself.
*   **Bottom Sheets & Dialogs:**
    *   **Direct Mutation** (e.g., editing a field, toggling a filter that instantly changes the page behind it): Use a **Single Shared BLoC** via `BlocProvider.value(...)` when opening the sheet. The sheet directly dispatches events to the parent BLoC.
    *   **Isolated/Complex Flow** (e.g., a multi-step checkout or deep form inside the sheet only): Use a **Dedicated Bottom Sheet BLoC** via `BlocProvider(create: ...)`. If the parent page needs the final result, pass it back via `Navigator.pop(context, result)`.
*   **Event Concurrency (`bloc_concurrency`):** **DO** use event transformers to control how events are processed:
    *   `droppable()` — Ignores new events while one is still processing (prevent double-tap submit or duplicate fetches).
    *   `restartable()` — Cancels the previous in-flight event and starts fresh (search-as-you-type, pull-to-refresh).
    *   `sequential()` — Queues events and processes them one by one.
*   **Global Observer (`AppBlocObserver`):** **DO** register a global `BlocObserver` in `main()` via `Bloc.observer = AppBlocObserver()`. It logs all events, transitions, and errors in debug mode only (`kDebugMode`). Placed in `lib/core/services/`.

## 3. Data Models & Serialization
*   **DO NOT** manually write or paste `fromJson` / `toJson` methods.
*   **DO** use `json_serializable` and `build_runner` for all data models. This ensures type safety and prevents runtime crashes due to malformed JSON.
*   **Immutability (Nested Models):** **DO** add `copyWith` methods to all nested data models. When modifying a deeply nested property, you must create a new instance of every object up the chain to trigger UI rebuilds via `Equatable`.
*   Models must include `part 'model_name.g.dart';` and the `@JsonSerializable()` annotation.

## 4. Linting & Code Quality
*   **DO NOT** use the default `flutter_lints`.
*   **DO** use `very_good_analysis` as the base linting package in `analysis_options.yaml`. This is the official ruleset by the creators of Bloc and enforces all `bloclibrary.dev/lint` best practices (like strict typing, avoiding public properties in Blocs, and proper event handling).

## 5. Routing & Deep Links (GoRouter)
*   **DO NOT** use native Navigator 1.0 push/pop or massive switch statements to parse URLs.
*   **DO** use `go_router` for declarative routing.
*   **Deep Links:** GoRouter natively handles Deep Links and Universal Links. You do not need an `AppLinksHandler`. Simply define your route paths with parameters (e.g., `path: '/products/:id'`). When the OS receives a deep link, GoRouter automatically intercepts it, extracts the ID, and navigates to the correct page natively.

## 6. Networking (Dio + Either Pattern)
*   **DO** use `Dio` with interceptors (Request, Error, Retry via `dio_smart_retry`).
*   **DO** use a `QueuedInterceptor` (e.g. `AuthInterceptor`) to handle Bearer tokens and 401 Unauthorized errors. It must pause outgoing requests, refresh the token via Secure Storage, and retry the paused requests seamlessly to prevent race conditions.
*   **DO NOT** throw raw exceptions from the Repository to the Bloc.
*   **DO** wrap repository responses in an `Either` or `Result` pattern (using `fpdart`'s `Either<Failure, SuccessData>`). 
*   The Bloc should receive the `Either` and `fold()` it into a success or failure state.

## 7. UI & Responsiveness (Phone First)
*   **DO** use `flutter_screenutil` to translate Figma designs into pixel-perfect UIs using `.w`, `.h`, `.r`, and `.sp`.
*   **DO** lock the app orientation to Portrait Mode in `main.dart` using `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);` to prevent UI shattering on tilt.
*   **Android Safety (Foldables/Tablets):** In `android/app/src/main/AndroidManifest.xml`, set `android:resizeableActivity="false"` and `android:screenOrientation="portrait"`. This prevents Android 12L+ and foldables from forcing your app into split-screen or bizarre aspect ratios, keeping it safe on the Play Store.
*   **iOS Safety (Tablets):** **DO NOT** target iPads unless explicitly required. When building for production, open the iOS `Runner.xcworkspace` and **uncheck iPad** under Deployment Info so the app runs in iPhone compatibility mode with black borders.

## 8. Localization, Flavors & Environments
*   **Localization:** Use `flutter_localizations` with standard `.arb` files (`app_en.arb`, `app_id.arb`).
*   **Flavors:** Use native flavors (Android ProductFlavors & iOS Schemes) managed via `flutter_flavorizr`.
*   **Environment Variables:** **DO** use `--dart-define-from-file=env_dev.json` to securely inject secrets at compile time. **DO NOT** use unencrypted `.env` files or hardcode API keys. Access variables via `String.fromEnvironment`.

## 9. Testing Strategy
*   **Mocking:** **DO** use `mocktail` (not `mockito`). No code generation is needed.
*   **BLoC Tests:** **DO** use `bloc_test` to verify that events produce the expected sequence of states. Use `mocktail` to inject fake repositories.
*   **Repository Tests:** **DO** test that the repository correctly wraps API responses (and `DioException`s) in `fpdart`'s `Either` pattern. Mock the `Dio` instance using `mocktail`.
*   **Widget Tests:** **DO** mock the BLoC using `MockBloc` (from `bloc_test`) to force specific states (loading, success, failure) and verify the UI renders correctly without hitting real APIs.
*   **Integration Tests:** **DO** write end-to-end tests in `integration_test/` that mount the full `App` widget, hit real (or staging) APIs, and verify full user flows using `pumpAndSettle()`.

## 10. Analytics & Crash Reporting
*   **DO NOT** directly use `FirebaseAnalytics.instance` or `FirebaseCrashlytics.instance` throughout your UI or BLoCs. This tightly couples your app to Firebase and makes it hard to swap to Mixpanel/Amplitude or mock during testing.
*   **DO** abstract them behind generic interfaces (e.g., `AnalyticsService` and `CrashReportingService`).
*   **DO** inject these services into your global `AppBlocObserver`. This allows you to automatically log every `onEvent` as an analytics event and report every `onError` to Crashlytics without writing boilerplate in every single BLoC.

---
*Auto-generated during the /grill-me session to enforce consistency across all projects.*
