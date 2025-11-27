# Agents Brief

## Overview
MyTasks is a lightweight, offline-first, open-source Flutter task manager. It focuses on ultra-fast capture and completion of personal todos without ads, tracking, or network calls.

## Operating Principles
1. Keep every flow single-screen and responsive; avoid extra steps that slow task capture.
2. Persist all data locally on device storage; never send data to external services.
3. Favor small, deterministic UI updates so regressions are easy to trace.
4. When in doubt, prefer simplicity over new surface area—this app should feel instant.

## Coordination
- Platform: Flutter (stable channel, current SDK per `pubspec.yaml`).
- Scope: local task CRUD, optional reminders, no third-party integrations.
- Ownership & contact: mail@airat.top.

Respect these boundaries so agents stay aligned with the app’s promise of privacy-first productivity.
