import 'package:flutter/material.dart';

class AddHeaderDialog extends StatefulWidget {
  const AddHeaderDialog({super.key});

  @override
  State<AddHeaderDialog> createState() => _AddHeaderDialogState();
}

class _AddHeaderDialogState extends State<AddHeaderDialog> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Header'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _keyController,
            decoration: const InputDecoration(
              labelText: 'Header Key',
              hintText: 'Content-Type',
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _valueController,
            decoration: const InputDecoration(
              labelText: 'Header Value',
              hintText: 'application/json',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_keyController.text.isNotEmpty &&
                _valueController.text.isNotEmpty) {
              Navigator.pop(context, {
                'key': _keyController.text,
                'value': _valueController.text,
              });
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
