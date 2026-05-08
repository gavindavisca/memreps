# Developer Guide

This document provides instructions for setting up the development environment, running the project locally, and deploying changes.

## Prerequisites

To contribute to this project, you need the following tools installed on your machine:

### 1. Flutter & Dart
- Install the **Flutter SDK** (Stable channel).
- Ensure `flutter` and `dart` are in your system's PATH.
- Verify the installation:
  ```bash
  flutter doctor
  ```

### 2. Java Development Kit (JDK)
- Install **Adoptium JDK** (LTS version, e.g., JDK 17 or 21). This is required for Android builds and some Firebase tools.
- Set the `JAVA_HOME` environment variable.

### 3. Node.js & Firebase CLI
- Install **Node.js** (Version 22 is recommended as specified in `functions/package.json`).
- Install the **Firebase CLI** globally:
  ```bash
  npm install -g firebase-tools
  ```
- Login to Firebase:
  ```bash
  firebase login
  ```

---

## Local Development

### 1. Install Dependencies
Run the following command in the root directory to fetch Flutter dependencies:
```bash
flutter pub get
```

For Cloud Functions, navigate to the `functions` directory and install npm packages:
```bash
cd functions
npm install
cd ..
```

### 2. Code Generation
This project uses `drift` and `build_runner` for database code generation. If you modify database schemas or models, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Running the App
To run the Flutter web application in debug mode:
```bash
flutter run -d chrome
```

### 4. Running Firebase Emulators
To test Firebase features (like Hosting and Functions) locally:
```bash
firebase emulators:start
```

---

## Deployment

### 1. GitHub Pages
The web application is automatically deployed to GitHub Pages when changes are pushed to the `main` branch via a GitHub Action.

To build the web app manually with the correct base href:
```bash
flutter build web --release --base-href "/memreps/"
```

### 2. Firebase
To deploy Cloud Functions and Firebase Hosting:
```bash
firebase deploy --only functions,hosting
```
