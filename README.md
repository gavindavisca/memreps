# 🌐 Memreps - App

A modern, multilingual Flutter application designed to help parliamentary pages and constituents memorize the names of their elected representatives from their picture.  Available for Android and iOs devices.

## 🚀 Features

- **Multilingual Support**: `Switch between English (EN) and French (FR) on the fly.
- **Profile Management**: Save user profiles including name and preferred language.
- **Data-Driven**: Seamlessly integrates with the `representatives.json` dataset.
- **Responsive Design**: Built with Flutter's adaptive UI for a great experience on both mobile and desktop.

## 📂 Project Structure

- `lib/main.dart`: Entry point of the application.
- `lib/logic/l10n.dart`: Localization and internationalization utilities.
- `lib/models/representative.dart`: Data model for representative information.
- `lib/ui/profile_selection_screen.dart`: Screen for selecting language and legislature.
- `lib/ui/representative_list_screen.dart`: Main screen to view and memorize representatives.

## 📋 Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (Version 3.x or higher recommended).
- Dart (included with Flutter).

## 🛠️ Setup & Installation

1.  **Clone the repository** (or download the source code):
    ```bash
    git clone <repository-url>
    cd memreps
    ```

2.  **Run the app**:
    ```bash
    flutter run
    ```
    This command will build and launch the application on your default device.
    To specify a device:
    ```bash
    flutter run -d <device_id>
    ```

## 📚 Dataset

The application uses the `data/representatives.json` file to fetch the list of representatives. You can update this file to reflect the latest information for your specific legislature.

## 📱 Running on Android

To run the app on an Android device, ensure USB debugging is enabled and your device is connected. You can see available devices with:

```bash
flutter devices
```
