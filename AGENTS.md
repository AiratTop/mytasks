# Agents Brief

## Overview
MyTasks is an offline-first, open-source Flutter task manager for instant capture and completion of personal todos. It runs without analytics, ads, or network calls; everything is stored on-device via `shared_preferences`.

## Operating Principles
1. Keep flows single-screen, responsive, and optimized for thumb reach.
2. Block duplicate titles and show inline validation errors inside the add-task sheet.
3. Persist all state locally; never introduce networking, telemetry, or remote sync.
4. Favor deterministic UI updates—new tasks prepend, completions remove in place, and theme toggles apply immediately.
5. Respect users’ control: default to system theme but always expose the toolbar toggle and persist the choice in `_themeModeKey`.

## Current Surface Area
- Task CRUD list with checkbox completion.
- Bottom-sheet capture with duplicate validation.
- Theme toggle in the AppBar; mode stored locally.
- Launcher icons generated from `assets/icon/icon.png` via `flutter_launcher_icons`.
- Widget test `test/widget_test.dart` covering add/duplicate/delete flows.

## Coordination
- Platform: Flutter (stable channel defined in `pubspec.yaml`).
- Scope: local task management only (no reminders, sync, or integrations unless spec changes).
- Contact & ownership: mail@airat.top.

Stay inside these constraints to preserve the privacy-first promise and keep the project release-ready.
