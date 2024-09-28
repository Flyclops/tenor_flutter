import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tenor_dart/tenor_dart.dart';

class TenorCategoryStyle {
  /// Allows you to set a fallback decoration for people to see if the image loads slow or fails.
  final Decoration decoration;

  /// How tall you want the tappable category to be.
  final double height;

  /// Color that shows between the category text and image.
  final Color imageOverlayColor;

  /// Control how the category text looks.
  final TextStyle textStyle;

  /// Used to stop text from touching the edges when `FittedBox` kicks in.
  final EdgeInsets padding;

  const TenorCategoryStyle({
    this.decoration = const BoxDecoration(
      color: Color(0xFFBEB9AC),
    ),
    this.height = 100,
    this.imageOverlayColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.padding = const EdgeInsets.all(8),
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  });
}

class TenorCategoryWidget extends StatelessWidget {
  final TenorCategory? category;
  final Function(TenorCategory)? onTap;
  final TenorCategoryStyle style;

  const TenorCategoryWidget({
    this.category,
    this.onTap,
    this.style = const TenorCategoryStyle(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // for promotion
    final tenorCategory = category;
    final tenorCategoryImage = tenorCategory?.image;

    // early out
    if (tenorCategory == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => onTap?.call(tenorCategory),
      child: Container(
        height: style.height,
        decoration: style.decoration,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (tenorCategoryImage != null && tenorCategoryImage.isNotEmpty)
              ExtendedImage.network(
                tenorCategoryImage,
                cache: true,
                gaplessPlayback: true,
                fit: BoxFit.cover,
              ),
            Container(
              color: style.imageOverlayColor,
              alignment: Alignment.center,
              padding: style.padding,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  tenorCategory.searchTerm,
                  style: style.textStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
