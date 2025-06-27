// File: lib/features/todos/presentation/widgets/add_todo_dialog.dart

import 'package:flutter/material.dart';

class AddTodoDialog extends StatefulWidget {
  final Function(String) onAdd;
  const AddTodoDialog({super.key, required this.onAdd});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Yeni Görev Ekle"),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: "Görev açıklaması"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("İptal"),
        ),
        FilledButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onAdd(_controller.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text("Ekle"),
        ),
      ],
    );
  }
}