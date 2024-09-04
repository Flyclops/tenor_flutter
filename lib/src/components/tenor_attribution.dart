import 'package:flutter/material.dart';

class TenorAttribution extends StatelessWidget {
  const TenorAttribution({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom
            : 8,
      ),
      child: Center(
        child: _logo(context),
      ),
    );
  }

  Widget _logo(BuildContext context) {
    const basePath = "assets/";
    String logoPath = Theme.of(context).brightness == Brightness.light
        ? "powered_by_dark.png"
        : "powered_by_light.png";

    return Container(
      width: double.maxFinite,
      height: 15,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage(
            "$basePath$logoPath",
            package: 'tenor_flutter',
          ),
        ),
      ),
    );
  }
}
