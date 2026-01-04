import 'package:flutter/material.dart';

class ResponseBodyViewer extends StatelessWidget {
  final String body;

  const ResponseBodyViewer({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF3D3D3D)
                    : Colors.grey.shade300,
              ),
            ),
          ),
          child: Row(
            children: [
              // Left side - Format selector and actions
              Row(
                children: [
                  DropdownButton<String>(
                    value: 'JSON',
                    items: const [
                      DropdownMenuItem(value: 'JSON', child: Text('{} JSON')),
                      DropdownMenuItem(value: 'XML', child: Text('XML')),
                      DropdownMenuItem(value: 'HTML', child: Text('HTML')),
                      DropdownMenuItem(value: 'Text', child: Text('Text')),
                    ],
                    onChanged: (_) {},
                    underline: Container(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.preview, size: 18),
                    onPressed: () {},
                    tooltip: 'Preview',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility, size: 18),
                    onPressed: () {},
                    tooltip: 'Visualize',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ],
              ),
              const Spacer(),
              // Right side - Actions
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.format_align_left, size: 18),
                    onPressed: () {},
                    tooltip: 'Format',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, size: 18),
                    onPressed: () {},
                    tooltip: 'Filter',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, size: 18),
                    onPressed: () {},
                    tooltip: 'Search',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () {},
                    tooltip: 'Copy',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  IconButton(
                    icon: const Icon(Icons.link, size: 18),
                    onPressed: () {},
                    tooltip: 'Link',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Save Response',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 18),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Body content
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).cardTheme.color,
            child: body.isEmpty
                ? Center(
                    child: Text(
                      '(empty)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                : SingleChildScrollView(
                    child: SelectableText(
                      body,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
