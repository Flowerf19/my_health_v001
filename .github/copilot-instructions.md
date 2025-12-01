# AI Coding Guidelines for my_health_v002

## Project Overview
A Flutter health app integrating wearable devices (Mi Fit, Samsung, etc.) with Firebase backend and AI chatbot support using Google Gemini. Users track biometrics, log food, and chat with AI for health advice.

## Architecture
- **Clean Architecture**: `features/` for domain logic, `core/` for shared utilities, `screens/` for UI, `services/` for data, `models/` for data structures.
- **State Management**: Provider for dependency injection and state (e.g., AuthProvider in `features/auth/providers/`).
- **Data Flow**: Auth via Firebase Auth, health data via `health` package to Firestore, chat via Gemini API cached in Firestore.
- **Routing**: Centralized in `lib/core/routes/app_routes.dart` with named routes like `/home`, `/chat`.

## Key Patterns
- **Models**: Firestore serialization with `fromFirestore()` and `toFirestore()` (see `lib/models/user_model.dart`).
- **Services**: Singleton-like classes for API calls (e.g., `GeminiService` stores chat history locally and in Firestore).
- **Themes**: Centralized in `lib/core/themes/app_theme.dart` using constants from `lib/core/constants/`.
- **Widgets**: Reusable components in `lib/core/widgets/` (e.g., `CustomButton`).
- **Features**: Each feature (auth, health_connect) has `providers/`, `screens/`, `services/` subdirs.

## Developer Workflows
- **Build/Run**: `flutter run` for development, `flutter build apk` for Android release.
- **Dependencies**: `flutter pub get` after changes; use `flutter pub outdated` to check updates.
- **Firebase**: Configure via `firebase_options.dart`; rules in `firestore.rules`.
- **Environment**: API keys in `.env` loaded with `flutter_dotenv`.
- **Health Integration**: Request permissions via `HealthConnectService`; data stored as `BiometricHistory` in Firestore.
- **Linting**: Follow `analysis_options.yaml` (Flutter lints); run `flutter analyze` to check code quality.

## Conventions
- **Naming**: CamelCase for classes, snake_case for files (e.g., `user_model.dart`).
- **Imports**: Relative paths within lib/, absolute for packages.
- **Error Handling**: Try-catch in services, rethrow for UI handling.
- **Comments**: Mix of English and Vietnamese; prefer English for new code.
- **Local Storage**: Use `shared_preferences` for simple key-value storage (e.g., user preferences).

## Examples
- Adding a new screen: Define route in `app_routes.dart`, create in `screens/`, navigate with `Navigator.pushNamed(context, '/route')`.
- New model: Add to `models/`, implement Firestore methods.
- API call: Extend `DatabaseService` for Firestore ops, use streams for realtime data.
- Health data sync: Use `HealthConnectService` to fetch from device and store in Firestore subcollection.

Reference: `README.md` for app description, `pubspec.yaml` for deps.</content>
<parameter name="filePath">c:\Users\ENGUYEHWC\Downloads\flutter_project\my_health_v001\.github\copilot-instructions.md