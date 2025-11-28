# MyTasks

MyTasks is a fast, offline-first, open-source task manager focused on instant capture and completion of personal todos. Everything stays on-device—no analytics, tracking, or network calls.

## Features

- 🔐 **Local-only storage** powered by `shared_preferences`, so tasks survive restarts without leaving the device.
- ⚡️ **Ultra-quick input** with a single-field bottom sheet that validates duplicates before saving.
- ✅ **Simple list flow**: new tasks appear at the top, tapping the checkbox completes and removes them.
- 🌓 **Inline theme toggle** in the toolbar plus automatic system-theme support.
- 🧪 **Widget test coverage** for add/duplicate/delete flows.

## Getting Started

```bash
flutter pub get
flutter run        # choose iOS Simulator, Android device, or Chrome
```

### Running tests

```bash
flutter test
```

### Building for release

```bash
# Android
flutter build appbundle

# iOS (requires Xcode & signing configured)
flutter build ipa
```

## App icons

Provide the production icon assets before shipping:

- Android: replace launcher icons under `android/app/src/main/res/mipmap-*/ic_launcher.png`.
- iOS: update the asset catalog at `ios/Runner/Assets.xcassets/AppIcon.appiconset`.
- macOS/Windows/Linux/Web: update their respective icon folders if you plan desktop/web releases.

(Optional) Add [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons) to automate generation across platforms.

## Project status before store submission

- [x] Bundle ID `top.airat.mytasks` set in Android/iOS/macOS targets.
- [x] MIT license & agents brief committed.
- [x] Analytics/network calls avoided.
- [ ] Final app icon & store artwork.
- [ ] App Store / Play Store listings (screenshots, privacy answers, age rating).
- [ ] Manual smoke tests on physical devices, sign-off builds, and upload via TestFlight/Play Console.

Contributions are welcome—open issues or PRs if you want to help improve the experience. Contact: `mail@airat.top`.
