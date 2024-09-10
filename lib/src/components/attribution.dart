import 'package:flutter/material.dart';

class TenorAttributionStyle {
  final Brightness brightnes;
  final double height;
  final EdgeInsets padding;

  const TenorAttributionStyle({
    this.brightnes = Brightness.light,
    this.height = 15,
    this.padding = const EdgeInsets.symmetric(
      vertical: 8,
    ),
  });
}

class TenorAttribution extends StatelessWidget {
  final TenorAttributionStyle style;

  const TenorAttribution({
    this.style = const TenorAttributionStyle(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // If safe area is required, add it.
      padding: MediaQuery.of(context).padding.bottom > 0
          ? style.padding.copyWith(
              bottom: MediaQuery.of(context).padding.bottom,
            )
          : style.padding,
      child: Center(
        child: _logo(context),
      ),
    );
  }

  Widget _logo(BuildContext context) {
    String logoPath = style.brightnes == Brightness.light
        ? 'powered_by_dark.png'
        : 'powered_by_light.png';

    return Container(
      height: style.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage(
            'assets/$logoPath',
            package: 'tenor_flutter',
          ),
        ),
      ),
      width: double.infinity,
    );
  }
}
