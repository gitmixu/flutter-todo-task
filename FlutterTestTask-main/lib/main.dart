import 'package:flutter/material.dart';
import 'widgets/todo_input.dart';

void main() {
  runApp(const MyApp());
}

/// pääsovellus
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Todo-listan näyttö
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

/// StatefulWidgetin tila
class _TodoListScreenState extends State<TodoListScreen> {
  /// Lista kaikista todoista
  final List<TodoItem> _todos = [];

  final TextEditingController _textController = TextEditingController();

  /// Lisää uuden todo-itemin
  void _addTodo(String title) {
    final trimmedTitle = title.trim();

    // estää tyhjän syötteen
    if (trimmedTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo title cannot be empty')),
      );
      return;
    }

    // estää dublikaatit
    final alreadyExists = _todos.any(
      (todo) => todo.title.toLowerCase() == trimmedTitle.toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo already exists')),
      );
      return;
    }

    // lisää uusi todo
    setState(() {
      _todos.add(
        TodoItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: trimmedTitle,
        ),
      );
    });

    _textController.clear();
  }

  /// vaihda suoritustila
  void _toggleTodo(String id) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == id);

      // indexWhere palauttaa -1, jos todoa ei löydy (estetään kaatuminen)
      if (index == -1) return;

      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  /// poista todo-item
  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // UUSI: eristetty input-widget (kauniimpi lajittelu koodissa)
          TodoInput(
            controller: _textController,
            onSubmit: _addTodo,
          ),

          Expanded(
            child: _todos.isEmpty
                ? const Center(
                    child: Text(
                      'No todos yet. Add some!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (_) => _toggleTodo(todo.id),
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTodo(todo.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// yksittäinen todo-item
class TodoItem {
  final String id;
  final String title;
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}
