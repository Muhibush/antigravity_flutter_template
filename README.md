# Antigravity Flutter Template 🚀

The **Antigravity Flutter Template** is a production-ready, highly opinionated boilerplate designed for senior engineering teams. It eliminates decision fatigue by enforcing strict architectural patterns, scalable folder structures, and high-performance libraries.

## 📖 The Blueprint

This template is strictly governed by the [Flutter Blueprint](flutter_blueprint.md). 
**Before contributing to this project, you MUST read the Blueprint.** It covers the non-negotiable rules for:
1. Feature-First Project Structure
2. BLoC State Management (`flutter_bloc`, `bloc_concurrency`)
3. Data Models (`json_serializable`)
4. Linting (`very_good_analysis`)
5. Routing (`go_router`)
6. Networking (`dio`, `fpdart`)
7. UI Responsiveness (`flutter_screenutil`)
8. Flavors & Environments (Dart Defines)
9. Testing Strategy (`bloc_test`, `mocktail`, `integration_test`)

## 🛠 Project Structure

```text
lib/
├── core/             # Infrastructure (network, routing, services, theme, env)
├── pages/            # Feature modules (each containing bloc, model, repo, widget)
├── shared/           # Shared components (blocs, models, repositories, widgets)
└── utils/            # Pure functions, extensions, formatters, and constants
```

## 🚀 Getting Started

This repository contains a fully working example app (`example_blue_print_app`) that fetches products from a fake API, demonstrating all architectural concepts perfectly.

### Prerequisites
* Flutter SDK (latest stable)
* Dart SDK

### Running the App

1. **Install dependencies**
   ```bash
   cd example_blue_print_app
   flutter pub get
   ```

2. **Generate serialization code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run a specific flavor & environment**
   The project uses `--dart-define-from-file` to securely inject secrets (never hardcode API keys!).
   ```bash
   # Run the Dev environment
   flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=env_dev.json

   # Run the Staging environment
   flutter run --flavor staging -t lib/main_staging.dart --dart-define-from-file=env_staging.json

   # Run the Prod environment
   flutter run --flavor prod -t lib/main_prod.dart --dart-define-from-file=env_prod.json
   ```

## 🧪 Testing

We use a strict 3-tier testing strategy (`mocktail`, `bloc_test`, `integration_test`).
```bash
# Run Unit & Widget tests
flutter test

# Run Integration tests (Requires an active emulator/device)
flutter test integration_test/app_test.dart
```

## 🧱 Creating a New Feature

This project uses `mason_cli` to instantly generate the massive amount of boilerplate required for a strict feature-first architecture. By using this generator, you ensure that every new feature perfectly aligns with the Antigravity Flutter Blueprint.

### 1. Setup in your Project

Because the generator is standalone, you need to add it to your project via a `mason.yaml` file. 

Create a `mason.yaml` in the root of your project:
```yaml
bricks:
  feature:
    git:
      url: https://github.com/Muhibush/antigravity_mason_bricks.git
      path: feature
```

Then, fetch the brick:
```bash
mason get
```

### 2. Generate the Boilerplate

When you need to build a new screen (e.g., a "Profile Settings" page), run the `feature` brick:
```bash
mason make feature --feature_name profile_settings
```

This will automatically create the following structure:
```text
lib/pages/profile_settings/
├── bloc/
│   ├── profile_settings_bloc.dart
│   ├── profile_settings_event.dart
│   └── profile_settings_state.dart
├── model/
│   └── profile_settings_model.dart
├── repository/
│   └── profile_settings_repository.dart
├── widget/
│   └── profile_settings_body.dart
└── profile_settings_page.dart
```

### 3. Manual Wiring Flow

Because we value safety and strict dependency injection over brittle code-generation regex, you must manually wire up the generated feature to the rest of the app:

1. **Routing**: Open `lib/core/routing/route_constants.dart` (or your GoRouter config file) and add the new route path (`/profile-settings`). Then map the route to the generated `ProfileSettingsPage`.
2. **Dependency Injection**: Open the generated `profile_settings_page.dart`. The `BlocProvider` has a `TODO` comment reminding you to inject your real `Dio` instance (or `ApiProvider`) into the Repository.
3. **Serialization**: Open a terminal and run the build runner to generate the `.g.dart` serialization file for the new data model:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

You are now ready to start writing your UI and business logic!

---
*Built with ❤️ by the Antigravity Architecture Team.*
