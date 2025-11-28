# Contributing to MyTasks

Thank you for taking the time to improve MyTasks! This project is a lightweight, offline-first Flutter app, so every bug fix, doc tweak, and feature suggestion matters. Feel free to open issues for discussion before coding if you are unsure about scope or approach.

## Ways to Help

- **Report bugs** with clear reproduction steps, device details, Flutter/Dart versions, and screenshots if possible.
- **Suggest enhancements** that stay aligned with the project goals: offline storage, privacy-first, and fast capture flows.
- **Improve docs** (README, `docs/` pages, CHANGELOG) so new contributors understand setup and release expectations.
- **Submit pull requests** for code changes, UI polish, localization, accessibility, or automated tests.

## Getting Started

1. Ensure you have the Flutter SDK (stable channel) and platform toolchains installed (`flutter doctor`).
2. Fork this repository and clone your fork locally.
3. Run `flutter pub get` to install dependencies.
4. Create a descriptive branch name (e.g., `feature/add-task-filter`).

## Development Workflow

1. Implement your change with focused commits.
2. Keep code consistent with `dart format` (run automatically by CI, but you can run `dart format .` locally).
3. Run the Flutter tests before opening a PR:
   ```bash
   flutter test
   ```
4. If you modify platform-specific files (Android/iOS icons, signing config, etc.), explain the steps you followed in the PR description.
5. Update `CHANGELOG.md` when behaviour changes or new features land.
6. Open a pull request against `main`, describing the motivation, implementation details, and validation steps.

## Pull Request Checklist

- [ ] Project builds locally: `flutter build ios` or `flutter build apk` when relevant.
- [ ] `flutter test` passes.
- [ ] `dart format` has been applied to modified Dart files.
- [ ] Docs/README/CHANGELOG updated when behaviour or UI changes.
- [ ] Screenshots attached for significant UI changes.
- [ ] No secrets or credentials committed (use `.env.example` or README instructions instead).

## Code Style & Guidelines

- Stick to Flutter/Dart idioms; prefer composition over inheritance when creating widgets.
- Keep widgets small and focused. Extract reusable pieces rather than adding complex logic to `main.dart`.
- Use `shared_preferences` for persistence unless we agree on a different storage solution.
- Avoid adding analytics, network calls, or third-party tracking—privacy is a core requirement.

## Communication & Support

If you encounter a security issue or need clarification, email [mail@airat.top](mailto:mail@airat.top). For general questions, open a GitHub discussion or issue—others might benefit from the answer as well.

Thanks again for contributing and helping keep MyTasks fast, private, and friendly!
