# Collaborative Shopping List App with Firebase

ShoppyList is a collaborative shopping list app built with Flutter and Firebase. It allows users to create or join shared lists, add or remove items in real time, and instantly see updates—powered by cloud-based synchronization.

## 🚀 Getting Started

### 🔧 Initial Setup

1. Change App Name
- Update the app name by modifying the AndroidManifest.xml file located at:
    ```
    android/app/src/main/AndroidManifest.xml
    ```

- Set the label attribute inside the <application> tag:
    ```
    android:label="ShoppyList"
    ```

2. Add App Icon
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

