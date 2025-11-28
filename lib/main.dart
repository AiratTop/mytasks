import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _storageKey = 'mytasks_items';
const _themeModeKey = 'mytasks_theme_mode';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyTasksApp());
}

class MyTasksApp extends StatefulWidget {
  const MyTasksApp({super.key});

  @override
  State<MyTasksApp> createState() => _MyTasksAppState();
}

class _MyTasksAppState extends State<MyTasksApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeModeKey);
    if (stored == null) return;
    setState(() => _themeMode = _themeModeFromString(stored));
  }

  void _toggleTheme(bool isDark) {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    setState(() => _themeMode = next);
    _persistThemeMode(next);
  }

  Future<void> _persistThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _themeModeToString(mode));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTasks',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _themeMode,
      home: TaskHomePage(onToggleTheme: _toggleTheme),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5),
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key, required this.onToggleTheme});

  final void Function(bool isDark) onToggleTheme;

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _tasks = <String>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? <String>[];
    setState(() {
      _tasks = stored;
      _loading = false;
    });
  }

  Future<void> _persistTasks(List<String> next) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, next);
  }

  Future<void> _addTask(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    final updated = List<String>.from(_tasks)..insert(0, trimmed);
    setState(() => _tasks = updated);
    await _persistTasks(updated);
  }

  Future<void> _completeTask(int index) async {
    final updated = List<String>.from(_tasks)..removeAt(index);
    setState(() => _tasks = updated);
    await _persistTasks(updated);
  }

  void _showAddTaskSheet() {
    _controller.clear();

    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        String? errorText;

        Future<void> submit(StateSetter setModalState) async {
          final value = _controller.text.trim();
          final validation = _validateTitle(value);
          if (validation != null) {
            setModalState(() => errorText = validation);
            return;
          }
          Navigator.of(ctx).pop(value);
        }

        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                24 + MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => submit(modalSetState),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: "Capture what's next",
                      errorText: errorText,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => submit(modalSetState),
                      icon: const Icon(Icons.check),
                      label: const Text('Add task'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      if (value != null) {
        _addTask(value);
      }
    });
  }

  String? _validateTitle(String value) {
    if (value.isEmpty) {
      return 'Enter a task title';
    }
    final exists = _tasks.any(
      (task) => task.toLowerCase() == value.toLowerCase(),
    );
    if (exists) return 'Task already exists';
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyTasks (${_tasks.length})',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            tooltip: isDarkMode
                ? 'Switch to light theme'
                : 'Switch to dark theme',
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.onToggleTheme(isDarkMode),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _tasks.isEmpty
              ? _EmptyState(onAddTap: _showAddTaskSheet)
              : ListView.separated(
                  key: const ValueKey('tasks-list'),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  itemCount: _tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Card(
                      child: ListTile(
                        leading: Checkbox(
                          value: false,
                          onChanged: (_) => _completeTask(index),
                          shape: const CircleBorder(),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        title: Text(
                          task,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskSheet,
        icon: const Icon(Icons.add),
        label: const Text('Task'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 42),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: scheme.outlineVariant,
            ),
            const SizedBox(height: 20),
            Text(
              'All clear',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Capture your next task and it will stay safely on this device.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onAddTap,
              child: const Text('Add your first task'),
            ),
          ],
        ),
      ),
    );
  }
}
