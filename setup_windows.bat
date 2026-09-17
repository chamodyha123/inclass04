@echo off
setlocal

where flutter >nul 2>&1
if errorlevel 1 (
  echo ERROR: Flutter was not found in PATH.
  echo Install Flutter, reopen the terminal, then run this file again.
  exit /b 1
)

echo Backing up supplied source files...
copy /Y lib\main.dart lib\main.dart.mini_cricket_backup >nul
copy /Y pubspec.yaml pubspec.mini_cricket_backup.yaml >nul

echo Creating platform files using your installed Flutter SDK...
flutter create . --project-name mini_cricket --org com.example
if errorlevel 1 goto :restore_error

echo Restoring supplied Mini Cricket source files...
copy /Y lib\main.dart.mini_cricket_backup lib\main.dart >nul
copy /Y pubspec.mini_cricket_backup.yaml pubspec.yaml >nul
del /Q lib\main.dart.mini_cricket_backup
del /Q pubspec.mini_cricket_backup.yaml

echo Getting packages...
flutter pub get
if errorlevel 1 exit /b 1

echo.
echo Setup complete. Run: flutter run
exit /b 0

:restore_error
echo Flutter project creation failed. Restoring source files...
copy /Y lib\main.dart.mini_cricket_backup lib\main.dart >nul
copy /Y pubspec.mini_cricket_backup.yaml pubspec.yaml >nul
del /Q lib\main.dart.mini_cricket_backup
del /Q pubspec.mini_cricket_backup.yaml
exit /b 1
