import 'package:flutter/material.dart';

class TenorDragHandle extends StatelessWidget {
  const TenorDragHandle({super.key});

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
