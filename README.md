# Chat App (Flutter + Firebase)

A simple one-to-one chat app built with Flutter and Firebase (Auth +
Cloud Firestore). Sign up with email/password, see who is online, tap a
user and start chatting.

## Features

- Email/password sign up and login (Firebase Auth)
- Online/offline presence (`isOnline` + `lastSeen` in Firestore)
- One-to-one realtime chat (Firestore stream, newest first)
- Server timestamps on messages so ordering is the same on every device

## Project structure

- `lib/main.dart` — Firebase init + named routes (`/login`, `/signup`, `/home`)
- `lib/screens/login_screen.dart`, `lib/screens/signup_screen.dart` — auth UI
- `lib/home_screen.dart` — user list; tap a user to open the chat
- `lib/screens/chat_screen.dart` — chat thread (messages stream + send box)
- `lib/services/auth_service.dart` — sign up / login / logout + presence
- `lib/models/user.dart` — `UserModel` (Firestore `users` document)

## Setup

1. Install Flutter (3.12+), then `flutter pub get`.
2. Generate the Firebase config (it is gitignored, so a fresh clone has
   none — the app does not compile without it):

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   This creates `lib/firebase_options.dart` and the platform config files
   (`google-services.json`, `GoogleService-Info.plist` — also gitignored).
3. In the Firebase console, enable **Authentication → Email/Password**
   and create a **Firestore Database**.
4. Run it: `flutter run` (web, Android, iOS, desktop).

> Firestore rules are not in this repo — the database was created in test
> mode. Before any real use, lock the rules down so a user can only read
> the `users` collection and only read/write messages they send or receive.

## Tests

```bash
flutter test
```

- `test/user_model_test.dart` — unit tests for `UserModel.fromMap` /
  `toMap` (field mapping, safe defaults, round-trip). These run without
  Firebase.
- The old template counter widget test was removed: the app has no
  counter, and widget tests need Firebase mocks (not set up yet).

## Known issues

- The chat query (`whereIn` on sender/receiver + `orderBy` timestamp)
  needs a Firestore composite index. The first time a chat opens,
  Firestore shows an error with a link to create it — follow the link
  once and it works.

## Changelog

### 2026-11-22

- Tapping a user on the home screen now opens the chat thread
  (`ChatScreen`) — before this, the tap only printed the name and the
  chat screen was unreachable dead code.
- Chat hardening: no more `currentUser!` crash if the session expires
  mid-chat, the message input controller is disposed, and messages use
  `FieldValue.serverTimestamp()` instead of the device clock.
- `UserModel.fromMap` now accepts both `Timestamp` and `DateTime` date
  values, so `toMap()` → `fromMap()` round-trips.
- New `test/user_model_test.dart` (4 tests); removed the stale template
  counter widget test.
- README rewritten: real setup steps, features, and structure.
