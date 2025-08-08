# Collaborative Shopping List App with Firebase

ShoppyList is a collaborative shopping list app built with Flutter and Firebase. It allows users to create or join shared lists, add or remove items in real time, and instantly see updates—powered by cloud-based synchronization.

## 🚀 Getting Started

### 🔧 Initial Setup

1. Create Flutter Project
```
flutter create shoppylist
cd shoppylist
```

2. Rename App Name
- Update the app name by modifying the AndroidManifest.xml file located at:
    ```
    android/app/src/main/AndroidManifest.xml
    ```

- Set the label attribute inside the <application> tag:
    ```
    android:label="ShoppyList"
    ```

3. Add App Icon
- Add Dependency
    In your pubspec.yaml, under dev_dependencies, add:
    ```
    flutter_launcher_icons: ^0.14.4
    ```

- Configure Icon Path
    Also in pubspec.yaml, add the following configuration:
    ```
    flutter_launcher_icons:
        android: true
        ios: false
        image_path: assets/images/app_icon.png


    flutter:
        uses-material-design: true

        assets:
            - assets/images/app_icon.png
    ```
    💡 Make sure the icon file app_icon.png exists at assets/images/.

- Generate Icons
    ```
    flutter pub run flutter_launcher_icons
    or
    dart run flutter_launcher_icons
    ```
    This will generate platform-specific app icons.


## 🔥 Firebase Integration

4. Add Required Dependencies
In pubspec.yaml:
```
 dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^4.0.0
  firebase_auth: ^6.0.0
  cloud_firestore: ^6.0.0
  firebase_storage: ^13.0.0
  get: ^4.7.2
```
  aslo with state management 
  ```
  get: ^4.7.2
  ```

5. Configure Firebase (Android)

- Register App in Firebase Console
    1. Go to [Firebase Console]()
    2. Create a project
    3. Add an Android app (use your app's package name, e.g., com.example.shoppylist)
    4. Download ```google-services.json```
    ⚠️ Place the google-services.json file in:
    ```
    android/app/google-services.json
    ```

- Update Gradle Files
```android/build.gradle.kts```:
Make sure to include:
```
plugins {
  id("com.google.gms.google-services") version "4.4.3" apply false
}
```

```android/app/build.gradle.kts```:
Add at the bottom of the file:
```
plugins {
    // Google services Gradle plugin
    id("com.google.gms.google-services")
}
```
If you steup firebase analytics, make sure to include:
```
dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:34.0.0"))
  implementation("com.google.firebase:firebase-analytics")
}
```
Also make sure minSdkVersion is at least 21:
```
defaultConfig {
    ...
    minSdkVersion 21
}
```

6. Initialize Firebase in App
In your ```main.dart```:
```
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

## ⚒️ Implementation Setup

### 🗂 Suggested Folder Structure
```
lib/
├── main.dart
├── app.dart
├── app/
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   └── bindings/
│       └── initial_binding.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_dimensions.dart
│   ├── services/
│   │   ├── firebase_service.dart
│   │   ├── auth_service.dart
│   │   └── storage_service.dart
│   └── utils/
│       ├── validators.dart
│       └── helpers.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── shopping_list_model.dart
│   │   └── list_item_model.dart
│   └── repositories/
│       ├── auth_repository.dart
│       ├── shopping_list_repository.dart
│       └── list_item_repository.dart
├── presentation/
│   ├── controllers/
│   │   ├── auth_controller.dart
│   │   ├── dashboard_controller.dart
│   │   ├── shopping_list_controller.dart
│   │   └── list_item_controller.dart
│   ├── pages/
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   ├── register_page.dart
│   │   │   ├── verify_email_page.dart
│   │   │   └── forgot_password_page.dart
│   │   ├── dashboard/
│   │   │   └── dashboard_page.dart
│   │   ├── shopping_list/
│   │   │   ├── create_list_page.dart
│   │   │   ├── join_list_page.dart
│   │   │   └── list_detail_page.dart
│   │   └── splash/
│   │       └── splash_page.dart
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── loading_widget.dart
│       └── list_item_card.dart

```

### 🔐 Authentication Flow 

- Email/password signup and login
- Verify email setup
- Forgot password setup
- Shared list management using Firestore

### 🔐 Firestore Security Rules
To enable collaborative shopping list features with proper access control, add the following Firestore rules in your Firebase Console:
<details> <summary>📄 Click to view full rules</summary>

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Allow each user to manage their own user profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Shopping List rules
    match /shopping_lists/{listId} {
      // Allow listing shopping lists by inviteCode
      allow list: if request.auth != null;

      // Allow reading if the user is in member list
      allow read: if request.auth != null &&
        request.auth.uid in resource.data.memberIds;

      // Allow creating if the user is listed in memberIds at creation
      allow create: if request.auth != null &&
        request.auth.uid in request.resource.data.memberIds;

      // Allow updating if user is in current or new member list and inviteCode is unchanged
      allow update: if request.auth != null &&
        (
          request.auth.uid in resource.data.memberIds || 
          (
            request.auth.uid in request.resource.data.memberIds &&
            resource.data.inviteCode == request.resource.data.inviteCode
          )
        );

      // Allow deletion if user is in member list
      allow delete: if request.auth != null &&
        request.auth.uid in resource.data.memberIds;
    }

    // Shopping List Items rules
    match /list_items/{itemId} {
      allow read: if request.auth != null;

      allow create: if request.auth != null &&
        exists(/databases/$(database)/documents/shopping_lists/$(request.resource.data.listId)) &&
        request.auth.uid in get(/databases/$(database)/documents/shopping_lists/$(request.resource.data.listId)).data.memberIds;

      allow update, delete: if request.auth != null &&
        exists(/databases/$(database)/documents/shopping_lists/$(resource.data.listId)) &&
        request.auth.uid in get(/databases/$(database)/documents/shopping_lists/$(resource.data.listId)).data.memberIds;
    }
  }
}
```

### 📚 Firestore Indexes
To support invite-based queries and efficient list filtering, make sure to create the following Firestore indexes:
#### Invite Code Query (when joining a list)
If your code queries shopping lists like this:
```
FirebaseFirestore.instance
.collection('shopping_lists')
.where('inviteCode', isEqualTo: code)
```

➡️ Then you need a single-field index on:
- inviteCode field (Ascending)
✅ Firebase usually creates this automatically, but if you see an error like FAILED_PRECONDITION: The query requires an index, click the Firebase Console link in the error or create it manually.

#### 📌 Optional: Composite Index (if needed)
If your app queries using multiple fields, such as:
```
.where('inviteCode', isEqualTo: code)
.where('memberIds', arrayContains: uid)
```
➡️ Then you'll need to create a composite index manually in Firebase.

#### 📍 How to Add Indexes

1. Go to Firestore Database → Indexes in Firebase Console
2. Click "Add Index"
Select:
- Collection: ```shopping_lists```
- Fields:
  - ```inviteCode``` — Ascending
  - (optional) ```memberIds``` — array-contains
  - Query scope: Collection

