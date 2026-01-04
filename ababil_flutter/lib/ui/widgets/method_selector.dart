import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MethodSelector extends StatefulWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;
  final List<String> methods;

  const MethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
    this.methods = const [
      'GET',
      'POST',
      'PUT',
      'PATCH',
      'DELETE',
      'HEAD',
      'OPTIONS',
    ],
  });

  @override
  State<MethodSelector> createState() => _MethodSelectorState();
}

class _MethodSelectorState extends State<MethodSelector> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final TextEditingController _customMethodController = TextEditingController();

  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.amber.shade300; // Light yellow/amber for POST
      case 'PUT':
        return Colors.blue;
      case 'PATCH':
        return Colors.purple;
      case 'DELETE':
        return Colors.orange.shade400; // Salmon/orange for DELETE
      case 'HEAD':
        return Colors.green;
      case 'OPTIONS':
        return Colors.pink.shade300; // Pink/magenta for OPTIONS
      default:
        return Colors.grey;
    }
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _hideDropdown(),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            Positioned(
              width: 200,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height),
                child: GestureDetector(
                  onTap: () {}, // Prevent closing when clicking inside
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 8,
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF3D3D3D)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Standard methods
                          ...widget.methods.map((method) {
                            final isSelected = method == widget.selectedMethod;
                            return InkWell(
                              onTap: () {
                                widget.onMethodChanged(method);
                                _hideDropdown();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.1)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  method,
                                  style: TextStyle(
                                    color: _getMethodColor(method),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }),
                          // Divider
                          Divider(
                            height: 1,
                            thickness: 1,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF3D3D3D)
                                : Colors.grey.shade300,
                          ),
                          // Custom method input
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: TextField(
                              controller: _customMethodController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Type a new method',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(fontSize: 12),
                              onSubmitted: (value) {
                                if (value.isNotEmpty &&
                                    !widget.methods.contains(
                                      value.toUpperCase(),
                                    )) {
                                  widget.onMethodChanged(value.toUpperCase());
                                }
                                _hideDropdown();
                                _customMethodController.clear();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customMethodController.dispose();
    _hideDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_overlayEntry == null) {
            _showDropdown();
          } else {
            _hideDropdown();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.selectedMethod,
                style: TextStyle(
                  color: _getMethodColor(widget.selectedMethod),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                CupertinoIcons.chevron_down,
                size: 8,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
