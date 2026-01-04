import 'package:flutter/material.dart';

class BodyPanel extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const BodyPanel({super.key, required this.controller, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Body', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              // Could add body type selector here (JSON, Text, etc.)
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF3D3D3D)
                      : Colors.grey.shade300,
                ),
              ),
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                decoration: InputDecoration(
                  hintText: hintText ?? 'Request body (JSON, text, etc.)',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(10),
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
