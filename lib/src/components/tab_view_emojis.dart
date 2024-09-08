import 'package:flutter/material.dart';
import 'package:tenor_flutter/src/components/tab_view.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorViewEmojis extends StatelessWidget {
  final Tenor client;

  const TenorViewEmojis({
    required this.client,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TenorTabView(
      client: client,
      keepAliveTabView: true,
      gifWidth: 80,
      onLoad: (queryText, pos, limit, category) async {
        if (queryText.isNotEmpty) {
          return await client.search(
            '$queryText emoji',
            mediaFilter: const [TenorMediaFormat.tinygifTransparent],
            pos: pos,
            limit: limit,
            sticker: true,
          );
        } else {
          return await client.search(
            'emoji',
            mediaFilter: const [TenorMediaFormat.tinygifTransparent],
            pos: pos,
            limit: limit,
            sticker: true,
          );
        }
      },
    );
  }
}
