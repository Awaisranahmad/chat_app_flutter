

---

## 🚀 Complete Firebase + Flutter Project Setup (SOP)

### Step 1: Flutter Project Create Karo

```bash
flutter create your_project_name
cd your_project_name
```

---

### Step 2: pubspec.yaml – Dependencies Add Karo

`pubspec.yaml` mein **dependencies:** section mein yeh add karo:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.12.0
  firebase_auth: ^5.5.0
  cloud_firestore: ^5.6.0
  provider: ^6.1.2
  intl: ^0.19.0
```

Phir:

```bash
flutter pub get
```

---

### Step 3: Firebase Console Mein Project Banao

1. [Firebase Console](https://console.firebase.google.com/) → **Create a project**
2. Project name: `your_project_name`
3. Google Analytics: **OFF** (skip)
4. **Create**

---

### Step 4: Flutter App Register Karo (Firebase Console)

1. Firebase Console → Project Overview → **Add app** → **Flutter** select karo.
2. Android package name: `com.example.your_project_name`
3. App nickname: `your_project_name`
4. **Register app** → `google-services.json` download karo → `android/app/` mein rakh do.
5. (iOS ke liye bhi same process – agar chahiye)

---

### Step 5: `firebase_options.dart` Generate Karo

Sab se **important step** – yeh automatic config generate karega.

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

**Prompts:**

| Prompt | Answer |
|--------|--------|
| "Select a Firebase project" | Apna project select karo |
| "Which platforms?" | **Space** se **web** check karo, baaki unchecked |
| "Which web app?" | `web` wala select karo |
| "Override firebase_options.dart?" | `y` |

✅ `firebase_options.dart` generate ho jayega.

---

### Step 6: Firebase Authentication Enable Karo

1. Firebase Console → **Authentication** → **Sign-in methods**
2. **Email/Password** → Enable karo → **Save**

---

### Step 7: Firestore Database Create Karo

1. Firebase Console → **Firestore Database** → **Create database**
2. Location: **asia-southeast1** (Singapore)
3. **Start in test mode** → Enable

---

### Step 8: `main.dart` Initialize Firebase

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

---

### Step 9: Services Folder Banao (Auth + Firestore)

```
lib/
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
├── models/
│   └── user.dart
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   └── home_screen.dart
└── main.dart
```

---

### Step 10: `auth_service.dart` – Boilerplate Code

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() => _auth.currentUser;

  Future<User?> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': userCredential.user!.uid,
        'isOnline': false,
        'lastSeen': DateTime.now(),
        'createdAt': DateTime.now(),
      });
      return userCredential.user;
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).update({
        'isOnline': true,
        'lastSeen': DateTime.now(),
      });
      return userCredential.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
```

---

### Step 11: `login_screen.dart` + `signup_screen.dart` + `home_screen.dart`

**(Copy from previous day's code – tu already likh chuka hai)**

---

### Step 12: Routes Setup in `main.dart`

```dart
initialRoute: '/login',
routes: {
  '/login': (context) => const LoginScreen(),
  '/signup': (context) => const SignupScreen(),
  '/home': (context) => const HomeScreen(),
},
```

---

### Step 13: Web Build + Deploy (Optional)

```bash
flutter build web
firebase init hosting  # build/web, Yes, No
firebase deploy --only hosting
```

---

## 📌 Quick Reference – Setup Checklist

| # | Step | Done? |
|---|------|-------|
| 1 | `flutter create` | ⬜ |
| 2 | `pubspec.yaml` dependencies | ⬜ |
| 3 | Firebase Console project | ⬜ |
| 4 | App register (Android + Web) | ⬜ |
| 5 | `google-services.json` place | ⬜ |
| 6 | `flutterfire configure` | ⬜ |
| 7 | `firebase_options.dart` generated | ⬜ |
| 8 | Auth enable (Email/Password) | ⬜ |
| 9 | Firestore create (test mode) | ⬜ |
| 10 | Services + Screens code | ⬜ |
| 11 | Routes setup | ⬜ |
| 12 | `flutter run` test | ⬜ |
| 13 | Deploy (optional) | ⬜ |

---

## 🔥 Next Time Tu Direct Yeh Steps Follow Karega!

- **Setup time:** 30-45 minutes (instead of 2-3 days 😄)
- **No `ERR_BLOCKED_BY_CLIENT`** – incognito mode mein test karo
- **No auth errors** – `flutterfire configure` sahi karega

---

## 📸 Batao

- Yeh steps copy kar liye?
- Kal naya project start karega toh follow karega?

**Ab tu pro ban gaya hai! 🚀💪**