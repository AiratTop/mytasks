#!/bin/bash

# Exit on error
set -e

echo "Cleaning project..."
flutter clean
flutter pub get

echo "Building for Web (WASM)..."
flutter build web --wasm
echo "Web artifact: build/web/ (deploy the contents of this directory)"

echo "Building Android APK..."
flutter build apk --release
echo "Android APK: build/app/outputs/flutter-apk/app-release.apk"

# echo "Building Android App Bundle for Google Play..."
# flutter build appbundle --release
# echo "Android App Bundle: build/app/outputs/bundle/release/app-release.aab"

# echo "Building for iOS..."
# flutter build ios --release
# echo "iOS archive: build/ios/iphoneos/Runner.app (archive with Xcode or flutter build ipa)"

echo "Building for macOS..."
flutter build macos --release
echo "macOS app: build/macos/Build/Products/Release/MyTasks.app"

echo "All builds completed successfully!"
