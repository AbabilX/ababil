import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
          // Workspace/New/Import
          TextButton(
            onPressed: () {},
            child: const Text('My Workspace', style: TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            child: const Text('New', style: TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            child: const Text('Import', style: TextStyle(fontSize: 13)),
          ),
          const Spacer(),
          // Tab indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.api,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'New Request',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Right side actions
          IconButton(
            icon: const Icon(Icons.save_outlined, size: 18),
            onPressed: () {},
            tooltip: 'Save',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 18),
            onPressed: () {},
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.code, size: 18),
            onPressed: () {},
            tooltip: 'Code',
          ),
        ],
      ),
    );
  }
}

