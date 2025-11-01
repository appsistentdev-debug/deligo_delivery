import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WidgetSize extends SingleChildRenderObjectWidget {
  const WidgetSize({
    super.key,
    required this.onChange,
    required Widget super.child,
  });

  final void Function(Size size) onChange;

  @override
  RenderObject createRenderObject(BuildContext context) => MeasureSizeRenderObject(onChange);
}

class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);

  void Function(Size size) onChange;

  Size _prevSize = Size.zero;

  @override
  void performLayout() {
    super.performLayout();
    Size newSize = child?.size ?? Size.zero;
    if (_prevSize == newSize) return;
    _prevSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
  }
}
