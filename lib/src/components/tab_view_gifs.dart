import 'package:flutter/material.dart';
import 'package:tenor_flutter/src/components/tab_view.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorViewGifs extends StatelessWidget {
  final Tenor client;
  final bool showCategories;
  final TenorTabViewStyle style;

  const TenorViewGifs({
    required this.client,
    this.showCategories = true,
    this.style = const TenorTabViewStyle(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TenorTabView(
      client: client,
      keepAliveTabView: true,
      showCategories: showCategories,
      gifWidth: 200,
      onLoad: (queryText, pos, limit, category) async {
        if (queryText.isNotEmpty) {
          return await client.search(
            queryText,
            pos: pos,
            limit: limit,
          );
        } else {
          if (showCategories) {
            // if a trending is selected, seatch them up
            if (category?.path == featuredCategoryPath) {
              return await client.featured(
                pos: pos,
                limit: limit,
              );
            }
            // don't hit the api since we already have the categories
            return null;
          }

          // ask for new featured gifs since categories are disabled
          return await client.featured(
            pos: pos,
            limit: limit,
          );
        }
      },
      style: style,
    );
  }
}
