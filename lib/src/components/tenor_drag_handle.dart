import 'package:flutter/material.dart';

class TenorDragHandle extends StatefulWidget {
  const TenorDragHandle({Key? key}) : super(key: key);

  @override
  State<TenorDragHandle> createState() => _TenorDragHandleState();
}

class _TenorDragHandleState extends State<TenorDragHandle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      width: 134,
      height: 4,
    );
  }
}
