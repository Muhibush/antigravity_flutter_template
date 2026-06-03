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

---
*Built with ❤️ by the Antigravity Architecture Team.*
