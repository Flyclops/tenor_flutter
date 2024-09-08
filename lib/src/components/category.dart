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
  final TenorCategoryStyle _style;

  const TenorCategoryWidget({
    this.category,
    this.onTap,
    TenorCategoryStyle? style,
    Key? key,
  })  : _style = style ?? const TenorCategoryStyle(),
        super(key: key);

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
        height: _style.height,
        decoration: _style.decoration,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (tenorCategoryImage != null)
              ExtendedImage.network(
                tenorCategoryImage,
                cache: true,
                gaplessPlayback: true,
                fit: BoxFit.cover,
              ),
            Container(
              color: _style.imageOverlayColor,
              alignment: Alignment.center,
              padding: _style.padding,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  tenorCategory.searchTerm,
                  style: _style.textStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
