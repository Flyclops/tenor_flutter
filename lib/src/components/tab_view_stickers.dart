import 'package:flutter/material.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorViewStickers extends StatelessWidget {
  final Tenor client;
  final int mediaWidth;
  final TenorTabViewStyle style;

  const TenorViewStickers({
    required this.client,
    this.mediaWidth = 150,
    this.style = const TenorTabViewStyle(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TenorTabView(
      client: client,
      keepAliveTabView: true,
      mediaWidth: mediaWidth,
      onLoad: (queryText, pos, limit, category) async {
        if (queryText.isNotEmpty) {
          return await client.search(
            queryText,
            mediaFilter: const [TenorMediaFormat.tinyGifTransparent],
            pos: pos,
            limit: limit,
            sticker: true,
          );
        } else {
          return await client.featured(
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
