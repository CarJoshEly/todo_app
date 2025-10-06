import 'package:flutter/material.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [];
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _dialogController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void _addTask() {
    if (_inputController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(_inputController.text));
        _inputController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _confirmationRemoveTask(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm deletion"),
        content: const Text("Are you sure you want to delete this assignment?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _removeTask(index);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _toggleTask(int index, bool? value) {
    setState(() {
      _tasks[index].done = value ?? false;
    });
  }

  void _editTask(int index) {
    _dialogController.text = _tasks[index].title;
    _descriptionController.text = _tasks[index].description;
    _dateController.text = _tasks[index].date;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _dialogController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Edit assignment...",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "Edit description...",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                hintText: "Edit due date...",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _dialogController.clear();
              _descriptionController.clear();
              _dateController.clear();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_dialogController.text.isNotEmpty) {
                setState(() {
                  _tasks[index].title = _dialogController.text;
                  _tasks[index].description = _descriptionController.text;
                  _tasks[index].date = _dateController.text;
                });
                _dialogController.clear();
                _descriptionController.clear();
                _dateController.clear();
                Navigator.of(context).pop();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int pendingTasks = _tasks.where((t) => !t.done).length;

    return Scaffold(
      appBar: AppBar(
        title: Text("My assignments ($pendingTasks pending )"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text("No task added!"))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: _tasks[index].done,
                            onChanged: (value) => _toggleTask(index, value),
                          ),
                          title: Text(
                            _tasks[index].title,
                            style: TextStyle(
                              decoration: _tasks[index].done
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(
                            _tasks[index].date,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () => _editTask(index),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.insert_comment_outlined,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Description"),
                                      content: Text(
                                        _tasks[index].description.isNotEmpty
                                            ? _tasks[index].description
                                            : "No description provided.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text("Close"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _confirmationRemoveTask(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          _dialogController.clear();
          _descriptionController.clear();
          _dateController.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("New assignment"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _dialogController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "Write an assignments...",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Add a description...",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      hintText: "Set a due date...",
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _dialogController.clear();
                    _descriptionController.clear();
                    _dateController.clear();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_dialogController.text.isNotEmpty) {
                      setState(() {
                        _tasks.add(
                          Task(
                            _dialogController.text,
                            description: _descriptionController.text,
                            date: _dateController.text,
                          ),
                        );
                      });
                      _dialogController.clear();
                      _descriptionController.clear();
                      _dateController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _dialogController.dispose();
    super.dispose();
  }
}
