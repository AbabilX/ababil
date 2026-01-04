import 'package:flutter/material.dart';

class ResizableSidebar extends StatefulWidget {
  final Widget child;
  final double initialWidth;
  final double minWidth;
  final double maxWidth;

  const ResizableSidebar({
    super.key,
    required this.child,
    this.initialWidth = 240,
    this.minWidth = 180,
    this.maxWidth = 400,
  });

  @override
  State<ResizableSidebar> createState() => _ResizableSidebarState();
}

class _ResizableSidebarState extends State<ResizableSidebar> {
  late double _width;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _width = widget.initialWidth;
  }

  void _onPanUpdate(DragUpdateDetails details, double maxWidth) {
    setState(() {
      _width = (_width + details.delta.dx)
          .clamp(widget.minWidth, maxWidth.clamp(widget.minWidth, widget.maxWidth));
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final clampedWidth = _width.clamp(
          widget.minWidth,
          maxWidth.clamp(widget.minWidth, widget.maxWidth),
        );

        return Row(
          children: [
            // Sidebar
            SizedBox(
              width: clampedWidth,
              child: widget.child,
            ),
            // Resizable divider
            GestureDetector(
              onPanStart: (_) => setState(() => _isDragging = true),
              onPanUpdate: (details) => _onPanUpdate(details, maxWidth),
              onPanEnd: (_) => setState(() => _isDragging = false),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: Container(
                  width: 4,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      width: 1,
                      height: double.infinity,
                      color: _isDragging
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF3D3D3D)
                              : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

