import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _storageKey = 'mytasks_items';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyTasksApp());
}

class MyTasksApp extends StatelessWidget {
  const MyTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTasks',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const TaskHomePage(),
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
}

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

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

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
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
              Text('New task', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submitTask(ctx),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: "Capture what's next",
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _submitTask(ctx),
                  icon: const Icon(Icons.check),
                  label: const Text('Add task'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitTask(BuildContext sheetContext) {
    final value = _controller.text;
    _addTask(value).then((_) {
      if (sheetContext.mounted) {
        Navigator.of(sheetContext).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyTasks',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
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
                        trailing: IconButton(
                          icon: const Icon(Icons.more_horiz),
                          onPressed: null,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withOpacity(0.4),
                          disabledColor: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withOpacity(0.2),
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
