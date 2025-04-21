import 'package:flutter/material.dart';

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSize extends StatefulWidget {
  final Widget child;
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    super.key,
    required this.child,
    required this.onChange,
  });

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  Size? oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = context.findRenderObject();
      if (renderBox is RenderBox) {
        final newSize = renderBox.size;
        if (oldSize == null || oldSize != newSize) {
          oldSize = newSize;
          widget.onChange(newSize);
        }
      }
    });
    return widget.child;
  }
}
