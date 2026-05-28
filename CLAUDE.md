# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app
flutter run

# Run on a specific platform
flutter run -d chrome        # web
flutter run -d macos         # macOS desktop

# Build
flutter build web
flutter build apk
flutter build ios

# Analyze (linting)
flutter analyze

# Tests
flutter test
flutter test test/widget_test.dart   # single test file

# Code generation (Riverpod providers, .g.dart files)
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs

# Update dependencies
flutter pub get
flutter pub upgrade

# Firebase Functions (in /functions directory)
cd functions && npm run build
cd functions && npm run serve
```

## Architecture

This is a Flutter web app (also targets mobile/desktop) that displays forex trading signals from Firestore in real time. It uses **Riverpod** for state management throughout, with code generation via `riverpod_annotation` and `riverpod_generator`.

### Layer structure (per feature)

```
lib/features/<feature>/
  repositories/     # Firestore/Firebase data access; each has a .g.dart sibling
  viewmodels/       # Riverpod @riverpod class providers; hold AsyncValue state
  views/
    pages/          # Full-screen widgets
    widgets/        # Composable UI pieces
  models/           # Plain Dart models with fromMap/toMap
```

### App startup sequence (`lib/main.dart` → `lib/app/fsd_app.dart`)

1. Firebase is initialized in `main()`.
2. `FsdApp` (a `ConsumerWidget`) watches three providers simultaneously:
   - `connectivityViewModelProvider` — skipped on web (`kIsWeb`)
   - `authViewModelProvider` — triggers anonymous Firebase Auth sign-in
   - `themeModeProvider` — `StateProvider<ThemeMode>`, defaults to dark
3. On success, `HomePage` is rendered; failures route to `FailurePage`.

### Signals data flow

The core feature is `SignalsViewmodel` (`lib/features/signals/viewmodels/signals_viewmodel.dart`), a `@riverpod` class that:
- Opens a real-time Firestore stream on `activeSignalsStream()` (collection `all-signals`, `isActive == true`)
- On first snapshot, immediately calls `fetchInitialInactiveSignals(limit: 20)` to pre-load history
- Merges active + inactive signals into an in-memory `Map<String, SignalModel?>` keyed by document ID to avoid duplicates
- Exposes `fetchMoreSignals()` for infinite scroll (8 per page, cursor-based)
- `updateSignal()` diffs the model against the stored map and writes only changed fields to Firestore

`SignalsRepository` (`lib/features/signals/repositories/signals_repository.dart`) owns all Firestore queries. The Firestore collection name is `all-signals` (constant `FirestoreCollections.signalCollection`).

### Key models

- `SignalModel` — the primary data object; fields include `symbol`, `action` (BUY/SELL), `entry`, `sl`, `tp1/2/3`, `isSlHit`, `isTp1/2/3Hit`, `isActive`, `pipScale`, `pnlPips`, `freeChannelMessageID`, `vipChannelMessageID`, `analysisLink`, `analysisResultLink`.
- `UserAccountModel` — stored in Firestore `userdb` collection; tracks `isPremium`, `isAdmin`, `fcmToken`, `isAnonymous`.

### Theme

`themeModeProvider` is a plain `StateProvider<ThemeMode>` in `lib/core/theme/theme_provider.dart`. Light/dark themes are defined in `AppTheme` (`lib/core/theme/theme.dart`). Colors are centralized in `AppColors` (`lib/core/theme/app_colors.dart`).

### Code generation

Any file using `@riverpod` has a corresponding `.g.dart` file that must be regenerated after changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Files using generation include `*_repository.dart`, `*_viewmodel.dart` — all with `part '<filename>.g.dart';` declarations.

### Debug logging

`printDebug()` in `lib/debug/print_debug.dart` wraps `print()` and only emits in `kDebugMode`. All debug logs are prefixed with `=====>` for easy filtering.

### Firebase / backend

- Firestore rules: `firestore.rules`
- Firebase Functions (TypeScript): `functions/` — used for backend logic
- Remote Config template: `remoteconfig.template.json`
- Web hosting config: `firebase.json`
- The app uses anonymous Firebase Auth — users are signed in automatically on launch without any credential input.
