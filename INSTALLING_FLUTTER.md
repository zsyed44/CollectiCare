# Installing Flutter on VS Code

## Prerequisites
- Ensure your system meets the [Flutter system requirements](https://docs.flutter.dev/get-started/install)
- Install [Git](https://git-scm.com/downloads) (required for cloning the Flutter repository)
- Install [VS Code](https://code.visualstudio.com/download)

## Step 1: Install Flutter SDK
1. Download the latest Flutter SDK from the [official website](https://docs.flutter.dev/get-started/install)
2. Extract the downloaded file to a location of your choice (e.g., `C:\flutter` on Windows or `~/flutter` on macOS/Linux)
3. Add Flutter to your system path:
   - **Windows**: Add `C:\flutter\bin` to the system `PATH` variable
   - **macOS/Linux**: Add `export PATH="$PATH:`pwd`/flutter/bin"` to `~/.bashrc` or `~/.zshrc`

## Step 2: Verify Installation
Run the following command in a terminal:
```sh
flutter doctor
```
This command checks if Flutter is installed correctly and lists missing dependencies.

## Step 3: Install Flutter Extension for VS Code
1. Open VS Code
2. Go to **Extensions** (`Ctrl + Shift + X` or `Cmd + Shift + X` on macOS)
3. Search for **Flutter** and install the **Dart** and **Flutter** extensions

## Step 4: Install Required Dependencies
- Ensure you have an emulator (e.g., Android Emulator or iOS Simulator) or a physical device connected
- Install Android Studio (optional but recommended for Android development)
- Accept Android licenses:
  ```sh
  flutter doctor --android-licenses
  ```

## Step 5: Download Android Simulator
More information can be found on the Flutter website

## Troubleshooting
- If VS Code does not detect Flutter, restart the editor
- Run `flutter doctor` to check for missing dependencies
- Refer to the [Flutter documentation](https://docs.flutter.dev/get-started/install) for detailed installation steps
