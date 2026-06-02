# Antigravity Flutter Template

This repository is built using the **Antigravity Flutter Blueprint**, providing a robust, scalable architecture for senior-level development. It implements a feature-first approach with BLoC state management, GoRouter, and Dio for networking.

## Features & Architecture

*   **Feature-First Structure**: Pages and their logic (BLoC, models, repositories, widgets) are grouped together.
*   **State Management (BLoC)**: Follows the official `bloclibrary.dev` recommendations. Uses a single State class with a status enum (`enum BlocStatus { initial, loading, success, failure }`) and a `copyWith` method.
*   **Data Models**: Uses `json_serializable` and `build_runner` for safe and robust serialization.
*   **Networking**: Powered by `Dio` and the `Either` pattern (`fpdart`) to safely handle success and failure states without throwing raw exceptions to the BLoC.
*   **Routing**: Uses `go_router` for declarative routing and native deep-link handling.
*   **UI & Responsiveness**: Utilizes `flutter_screenutil` for pixel-perfect designs. Enforces Portrait Mode for consistent layouts across devices.
*   **Code Quality**: Strict linting enforced by `very_good_analysis`.
*   **Localization & Flavors**: Ready for multiple languages with `flutter_localizations` and separated environments using native flavors (`flutter_flavorizr`).

## Project Structure

```
lib/
├── core/             # Infrastructure (network, routing, services, theme)
├── pages/            # Feature modules (each containing bloc, model, repo, widget)
├── shared/           # Shared components (blocs, models, repositories, widgets)
└── utils/            # Pure functions, extensions, formatters, and constants
```

## Getting Started

### Prerequisites

*   Flutter SDK (latest stable version)
*   Dart SDK

### Setup

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate files (JSON serialization, etc.):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Development Guidelines

- **BLoC Events**: Name events exactly as actions that happened in the past: `Subject + Noun + PastTenseVerb` (e.g., `LoginButtonPressed`).
- **Data Models**: Do not manually write `fromJson`/`toJson`. Always use `json_serializable`.
- **Imports**: Ensure all feature imports are contained within their specific domains unless they are in `shared/`.

---
*Built with the Antigravity Flutter Blueprint.*
