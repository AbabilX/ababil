import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _selectedNavIndex =
      0; // 0=Collections, 1=Environments, 2=History, 3=Flows

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          // Narrow icon-only navigation sidebar
          Container(
            width: 48,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E1E1E)
                : Colors.grey.shade100,
            child: Column(
              children: [
                // My Workspace header (compact)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF3D3D3D)
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                  child: const Icon(Icons.lock_outline, size: 18),
                ),
                // Navigation icons
                Expanded(
                  child: Column(
                    children: [
                      _NavIcon(
                        icon: Icons.folder_outlined,
                        isSelected: _selectedNavIndex == 0,
                        onTap: () => setState(() => _selectedNavIndex = 0),
                        tooltip: 'Collections',
                      ),
                      _NavIcon(
                        icon: Icons.square_outlined,
                        isSelected: _selectedNavIndex == 1,
                        onTap: () => setState(() => _selectedNavIndex = 1),
                        tooltip: 'Environments',
                      ),
                      _NavIcon(
                        icon: Icons.history,
                        isSelected: _selectedNavIndex == 2,
                        onTap: () => setState(() => _selectedNavIndex = 2),
                        tooltip: 'History',
                      ),
                      _NavIcon(
                        icon: Icons.account_tree_outlined,
                        isSelected: _selectedNavIndex == 3,
                        onTap: () => setState(() => _selectedNavIndex = 3),
                        tooltip: 'Flows',
                      ),
                    ],
                  ),
                ),
                // Bottom icon
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF3D3D3D)
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.apps, size: 20),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'More options',
                  ),
                ),
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: Column(
              children: [
                // Header with workspace name
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
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
                      Text(
                        'My Workspace',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content view
                Expanded(child: _buildContentArea()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    switch (_selectedNavIndex) {
      case 0: // Collections
        return _CollectionsView();
      case 1: // Environments
        return const Center(child: Text('Environments - Coming soon'));
      case 2: // History
        return const Center(child: Text('History - Coming soon'));
      case 3: // Flows
        return const Center(child: Text('Flows - Coming soon'));
      default:
        return const SizedBox.shrink();
    }
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String tooltip;

  const _NavIcon({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            border: isSelected
                ? Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 3,
                    ),
                  )
                : null,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ),
    );
  }
}

class _CollectionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add and search
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'New Collection',
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search collections',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF3D3D3D)
                            : Colors.grey.shade300,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardTheme.color,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        // Collections list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              _CollectionItem(name: 'loadtesting', isExpanded: false),
              _CollectionItem(
                name: 'poruaa',
                isExpanded: true,
                requests: [
                  _RequestItem(method: 'POST', name: 'login', isSelected: true),
                  _RequestItem(method: 'GET', name: 'root'),
                  _RequestItem(method: 'GET', name: 'payment'),
                  _RequestItem(method: 'POST', name: 'payment/ipn'),
                  _RequestItem(method: 'GET', name: 'New Request'),
                  _RequestItem(method: 'GET', name: 'New Request'),
                ],
              ),
              _CollectionItem(
                name: 'Referral Marketing API',
                isExpanded: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CollectionItem extends StatefulWidget {
  final String name;
  final bool isExpanded;
  final List<_RequestItem>? requests;

  const _CollectionItem({
    required this.name,
    this.isExpanded = false,
    this.requests,
  });

  @override
  State<_CollectionItem> createState() => _CollectionItemState();
}

class _CollectionItemState extends State<_CollectionItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                  size: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.name,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded && widget.requests != null)
          ...widget.requests!.map((request) => request),
      ],
    );
  }
}

class _RequestItem extends StatelessWidget {
  final String method;
  final String name;
  final bool isSelected;

  const _RequestItem({
    required this.method,
    required this.name,
    this.isSelected = false,
  });

  Color _getMethodColor() {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.amber;
      case 'PUT':
        return Colors.blue;
      case 'PATCH':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Text(
              method,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getMethodColor(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
