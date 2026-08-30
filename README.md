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
- `lib/features`: domain/data/models/repository layers
- `lib/pages`: app screens
- `lib/widgets`: reusable UI widgets
- `test`: widget, page, and domain tests

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
- Firebase project configuration files are present

This repo already includes Android Firebase config and generated options:

- `android/app/google-services.json`
- `lib/firebase_options.dart`

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
flutter test test/pages/login_page_test.dart
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

- If Firebase initialization fails, verify `lib/firebase_options.dart` and platform configs are synced with your Firebase project.
- If Google sign-in fails on Android, ensure SHA keys and OAuth client IDs are configured in Firebase.
- If tests fail after UI changes, run the specific failing test file first, then run the full suite.

## Future Improvements

- Add integration tests for auth and employee CRUD flows
- Add test coverage reporting in CI
- Add environment-based configuration for staging/production APIs
- Expand desktop/web-specific UX refinements

## License

This project is intended for educational/assessment use. Add a formal license if you plan to distribute it publicly.
