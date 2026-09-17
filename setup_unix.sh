#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: Flutter was not found in PATH."
  echo "Install Flutter, reopen the terminal, then run this script again."
  exit 1
fi

restore_files() {
  if [ -f lib/main.dart.mini_cricket_backup ]; then
    cp lib/main.dart.mini_cricket_backup lib/main.dart
    rm -f lib/main.dart.mini_cricket_backup
  fi
  if [ -f pubspec.mini_cricket_backup.yaml ]; then
    cp pubspec.mini_cricket_backup.yaml pubspec.yaml
    rm -f pubspec.mini_cricket_backup.yaml
  fi
}

trap restore_files EXIT

echo "Backing up supplied source files..."
cp lib/main.dart lib/main.dart.mini_cricket_backup
cp pubspec.yaml pubspec.mini_cricket_backup.yaml

echo "Creating platform files using your installed Flutter SDK..."
flutter create . --project-name mini_cricket --org com.example

restore_files
trap - EXIT

echo "Getting packages..."
flutter pub get

echo
echo "Setup complete. Run: flutter run"
