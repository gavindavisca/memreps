# 🌐 Memreps - App

A modern, multilingual Flutter application designed to help parliamentary pages and constituents memorize the names of their elected representatives from their picture. Available for Web, Android, and iOS devices.

## 🚀 Features

- **Multilingual Support**: Switch between English (EN) and French (FR) on the fly.
- **Profile Management**: Save user profiles including name and preferred language.
- **Multiple Quiz Modes**: Name Match, Party Match, Riding Match, Face Match, Name Recall, and the challenging Final Test.
- **Spaced Repetition (FSRS)**: Smart FSRS algorithm prioritizes members needing review.
- **Leaderboards & Sync**: Synchronizes quiz results and user profiles via Firebase Cloud Functions and Firestore.

## 📂 Project Structure

- `lib/main.dart`: Entry point of the application.
- `lib/logic/l10n.dart`: Localization and internationalization utilities.
- `lib/logic/quiz_service.dart`: Quiz generation logic and mode definitions.
- `lib/ui/quiz_selection_screen.dart`: Screen for selecting quiz mode and filtering.
- `lib/ui/quiz_screen.dart`: Main quiz screen handling question rendering and scoring.
- `functions/index.js`: Firebase Cloud Functions backend for leaderboards, profile sync, and data proxying.

## 📋 Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (Version 3.x or higher recommended).
- Dart (included with Flutter).
- [Java JDK](https://www.oracle.com/java/technologies/downloads/) (JDK 17 or higher recommended; required for running Firebase Local Emulators).
- [Node.js](https://nodejs.org/) & [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`).

## 🛠️ Setup & Development

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd memreps
   ```

2. **Install Firebase Functions dependencies**:
   ```bash
   cd functions
   npm install
   cd ..
   ```

3. **Start Firebase Local Emulators**:
   ```bash
   firebase emulators:start
   ```

4. **Run the App in Chrome**:
   ```bash
   flutter run -d chrome
   ```

## 🚀 Deployment

To deploy Cloud Functions and Web Hosting to Firebase:

```bash
firebase deploy --only functions,hosting
```
