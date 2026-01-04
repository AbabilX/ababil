import 'package:flutter/material.dart';

class ResizableColumn extends StatefulWidget {
  final Widget topChild;
  final Widget bottomChild;
  final double initialTopHeight;
  final double minTopHeight;
  final double minBottomHeight;

  const ResizableColumn({
    super.key,
    required this.topChild,
    required this.bottomChild,
    this.initialTopHeight = 400,
    this.minTopHeight = 150,
    this.minBottomHeight = 150,
  });

  @override
  State<ResizableColumn> createState() => _ResizableColumnState();
}

class _ResizableColumnState extends State<ResizableColumn> {
  late double _topHeight;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _topHeight = widget.initialTopHeight;
  }

  void _onPanUpdate(DragUpdateDetails details, double maxHeight) {
    setState(() {
      _topHeight = (_topHeight + details.delta.dy).clamp(
        widget.minTopHeight,
        maxHeight - widget.minBottomHeight,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final availableHeight = maxHeight - 4; // Divider space

        return Column(
          children: [
            // Top panel
            SizedBox(
              height: _topHeight.clamp(
                widget.minTopHeight,
                availableHeight - widget.minBottomHeight,
              ),
              child: widget.topChild,
            ),
            // Resizable divider
            GestureDetector(
              onPanStart: (_) => setState(() => _isDragging = true),
              onPanUpdate: (details) => _onPanUpdate(details, availableHeight),
              onPanEnd: (_) => setState(() => _isDragging = false),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: Container(
                  height: 4,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      height: 1,
                      width: double.infinity,
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
            // Bottom panel
            Expanded(child: widget.bottomChild),
          ],
        );
      },
    );
  }
}
