import 'package:flutter/material.dart';

class TenorDragHandleStyle {
  final Decoration decoration;
  final double height;
  final EdgeInsets margin;
  final double width;

  const TenorDragHandleStyle({
    this.decoration = const BoxDecoration(
      color: Color(0xFF8A8A86),
      borderRadius: BorderRadius.all(
        Radius.circular(100),
      ),
    ),
    this.height = 4,
    this.margin = const EdgeInsets.symmetric(
      vertical: 8,
    ),
    this.width = 134,
  });
}

class TenorDragHandle extends StatelessWidget {
  final TenorDragHandleStyle _style;

  const TenorDragHandle({
    TenorDragHandleStyle style = const TenorDragHandleStyle(),
    super.key,
  }) : _style = style;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _style.decoration,
      height: _style.height,
      margin: _style.margin,
      width: _style.width,
    );
  }
}
