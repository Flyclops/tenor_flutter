import 'package:flutter/material.dart';
import 'package:tenor_flutter/src/utilities/is_tablet.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorViewEmojis extends StatelessWidget {
  final Tenor client;
  final int? gifsPerRow;
  final TenorTabViewStyle style;

  const TenorViewEmojis({
    required this.client,
    this.gifsPerRow,
    this.style = const TenorTabViewStyle(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TenorTabView(
      client: client,
      gifsPerRow: gifsPerRow ?? (isTablet(context) ? 8 : 2),
      keepAliveTabView: true,
      onLoad: (queryText, pos, limit, category) async {
        if (queryText.isNotEmpty) {
          return await client.search(
            '$queryText emoji',
            mediaFilter: const [TenorMediaFormat.tinyGifTransparent],
            pos: pos,
            limit: limit,
            sticker: true,
          );
        } else {
          return await client.search(
            'emoji',
            mediaFilter: const [TenorMediaFormat.tinyGifTransparent],
            pos: pos,
            limit: limit,
            sticker: true,
          );
        }
      },
      style: style,
    );
  }
}
