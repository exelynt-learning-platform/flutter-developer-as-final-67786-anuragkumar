# Employee Management App

A Flutter application for managing employees with Firebase authentication, Google sign-in, and responsive dashboards for mobile and desktop layouts.

## Overview

This project demonstrates a layered Flutter architecture using Riverpod for state management and GoRouter for navigation. It includes:

- Authentication flow (email/password and Google sign-in)
- Employee dashboard with search and filters
- Add/Edit employee form with validation
- Delete confirmation and refresh support
- Responsive UI components for mobile and desktop
- Widget and page-level tests

## Tech Stack

- Flutter (Dart SDK constraint: `^3.13.2`)
- `flutter_riverpod` for dependency injection and state management
- `go_router` for declarative navigation and route guards
- `dio` for API/client networking
- Firebase (`firebase_core`, `firebase_auth`)
- `google_sign_in` for OAuth sign-in
- `shared_preferences` for local persistence use cases

## Project Structure

Key folders:

- `lib/app`: app shell, router, and providers
- `lib/core`: shared concerns (theme, networking, validation, storage)
- `lib/features`: feature-first modules (auth, home, employee) with presentation/domain/data layers
- `lib/features/*/presentation/pages`: feature screens
- `lib/features/*/presentation/widgets`: feature-specific reusable widgets
- `lib/core/widgets`: app-wide reusable widgets
- `test/features`: feature-aligned tests
- `test/core`: shared/core widget tests
- `test/shared`: test doubles and fixtures

## Routes

Defined in `lib/app/router/app_router.dart`:

- `/login`: authentication screen
- `/`: home screen
- `/employees`: employee dashboard
- `/employees/add`: add employee form
- `/employees/edit/:id`: edit employee form (expects `Employee` via route extra)

Auth redirect behavior:

- Unauthenticated users are redirected to `/login`
- Authenticated users visiting `/login` are redirected to `/`

## Prerequisites

Before running the app, ensure:

- Flutter SDK is installed and available in PATH
- A device/emulator is available
- Firebase project values are provided through `--dart-define`

## Firebase Configuration (Secure Setup)

This project initializes Firebase from environment values passed at runtime/build time.

Do not commit production Firebase config files or generated options to a public repository.

Required `--dart-define` values:

- `FIREBASE_PROJECT_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_STORAGE_BUCKET` (optional)

Android:

- `FIREBASE_ANDROID_API_KEY`
- `FIREBASE_ANDROID_APP_ID`

Web/Windows:

- `FIREBASE_WEB_API_KEY` and `FIREBASE_WINDOWS_API_KEY`
- `FIREBASE_WEB_APP_ID` and `FIREBASE_WINDOWS_APP_ID`
- `FIREBASE_AUTH_DOMAIN`

iOS/macOS:

- `FIREBASE_IOS_API_KEY` and `FIREBASE_MACOS_API_KEY`
- `FIREBASE_IOS_APP_ID` and `FIREBASE_MACOS_APP_ID`
- `FIREBASE_IOS_BUNDLE_ID`

Example run command (Android):

```bash
flutter run \
	--dart-define=FIREBASE_PROJECT_ID=your-project-id \
	--dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id \
	--dart-define=FIREBASE_STORAGE_BUCKET=your-bucket \
	--dart-define=FIREBASE_ANDROID_API_KEY=your-android-api-key \
	--dart-define=FIREBASE_ANDROID_APP_ID=your-android-app-id
```

Tip: keep these values in local launch/task configs or CI secret variables.

Recommended local workflow (`--dart-define-from-file`):

- Copy `env/firebase.web.example.json` to `env/firebase.web.local.json`
- Copy `env/firebase.android.example.json` to `env/firebase.android.local.json`
- Fill in values in your local files
- Run with:

```bash
flutter run -d chrome --dart-define-from-file=env/firebase.web.local.json
```

```bash
flutter run --dart-define-from-file=env/firebase.android.local.json
```

The `.local.json` files are ignored by git to avoid committing secrets.

VS Code default run/debug support:

- Workspace setting `.vscode/settings.json` includes:
	- `dart.flutterRunAdditionalArgs` with `--dart-define-from-file=env/firebase.all.local.json`
- This means regular Run/Debug in VS Code also receives Firebase defines automatically.

Example run command (Web):

```bash
flutter run -d chrome \
	--dart-define=FIREBASE_PROJECT_ID=your-project-id \
	--dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id \
	--dart-define=FIREBASE_STORAGE_BUCKET=your-bucket \
	--dart-define=FIREBASE_AUTH_DOMAIN=your-project-id.firebaseapp.com \
	--dart-define=FIREBASE_WEB_API_KEY=your-web-api-key \
	--dart-define=FIREBASE_WEB_APP_ID=your-web-app-id
```

VS Code launch profiles are available in `.vscode/launch.json` for one-click run with local env files.

## Getting Started

1. Install dependencies:

```bash
flutter pub get
```

2. Verify setup:

```bash
flutter doctor
```

3. Run the app:

```bash
flutter run
```

## Testing

Run all tests:

```bash
flutter test
```

Run a specific test file:

```bash
flutter test test/features/auth/presentation/pages/login_page_test.dart
```

Current test coverage includes:

- Page tests: login, home, employee dashboard, add/edit employee
- Widget tests: text control, employee card/list/filters, responsive helpers
- Domain/provider tests under `test/features`

## Validation Rules and UX Notes

- Employee form uses validators for name, email, and mobile
- Country selection is required
- Save action is disabled while invalid or during submission
- Login page includes responsive layout handling for narrow widths

## Common Commands

```bash
flutter analyze
flutter test
flutter clean
flutter pub get
```

## Troubleshooting

- If Firebase initialization fails, verify all required `--dart-define` keys are supplied for the platform you are running.
- If Google sign-in fails on Android, ensure SHA keys and OAuth client IDs are configured in Firebase.
- If tests fail after UI changes, run the specific failing test file first, then run the full suite.

## Future Improvements

- Add integration tests for auth and employee CRUD flows
- Add test coverage reporting in CI
- Add environment-based configuration for staging/production APIs
- Expand desktop/web-specific UX refinements

## License

This project is intended for educational/assessment use. Add a formal license if you plan to distribute it publicly.
