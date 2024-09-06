// ignore_for_file: implementation_imports
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tenor_flutter/src/components/components.dart';
import 'package:tenor_flutter/src/models/attribution.dart';
import 'package:tenor_flutter/src/models/type.dart';
import 'package:tenor_flutter/src/providers/app_bar_provider.dart';
import 'package:tenor_flutter/src/providers/style_provider.dart';
import 'package:tenor_flutter/src/providers/tab_provider.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorTabViewStyle {
  const TenorTabViewStyle();
}

class TenorTabViewDetail extends StatefulWidget {
  final String type;
  final Function(TenorResult? gif)? onSelected;
  final bool showCategories;
  final bool? keepAliveTabView;
  final int gifWidth;

  const TenorTabViewDetail({
    Key? key,
    required this.type,
    this.showCategories = false,
    this.onSelected,
    this.keepAliveTabView,
    required this.gifWidth,
  }) : super(key: key);

  @override
  _TenorTabViewDetailState createState() => _TenorTabViewDetailState();
}

class _TenorTabViewDetailState extends State<TenorTabViewDetail>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.keepAliveTabView ?? true;

  // Tab Provider
  late TenorTabProvider _tabProvider;

  late TenorStyle _tenorStyle;

  late TenorTabViewStyle _style;

  late final ScrollController scrollController;

  // AppBar Provider
  late TenorAppBarProvider _appBarProvider;

  // Collection
  TenorResponse? _collection;

  // List of gifs
  List<TenorResult> _list = [];

  // Direction
  final Axis _scrollDirection = Axis.vertical;

  // Axis count
  late int _crossAxisCount;

  // Limit of query
  late int _limit;

  // is Loading gifs
  bool _isLoading = false;

  // Offset
  String? offset;

  List<TenorCategory?> _categories = [];

  late final Tenor client;

  @override
  void initState() {
    super.initState();

    // sheet
    scrollController = ScrollController();

    // Tab Provider
    _tabProvider = Provider.of<TenorTabProvider>(context, listen: false);

    // AppBar Provider
    _appBarProvider = Provider.of<TenorAppBarProvider>(context, listen: false);

    // Styles
    _tenorStyle = Provider.of<TenorStyleProvider>(context, listen: false).style;
    _style = _tenorStyle.tabViewDetailStyle ?? const TenorTabViewStyle();

    // setup client
    client = _tabProvider.client;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCount();
      if (widget.showCategories == false) {
        _loadMore();
      } else {
        _loadCatagories();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ScrollController
    scrollController.addListener(_scrollListener);

    // Listen query
    _appBarProvider.addListener(_listenerQuery);

    getCount();

    // Initial offset
    offset = null;
  }

  void getCount() {
    // Set items count responsive
    _crossAxisCount =
        (MediaQuery.of(context).size.width / widget.gifWidth).round();

    // Set vertical max items count
    int _mainAxisCount =
        ((MediaQuery.of(context).size.height - 30) / widget.gifWidth).round();

    // Calculate the visible limit
    _limit = _crossAxisCount * _mainAxisCount;

    // Tenor has a hard limit of 50
    if (_limit > 50) _limit = 50;
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    _appBarProvider.removeListener(_listenerQuery);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_list.isEmpty && _categories.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_appBarProvider.queryText.isEmpty && widget.showCategories) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: MasonryGridView.count(
          controller: scrollController,
          crossAxisCount: _crossAxisCount,
          crossAxisSpacing: 8,
          itemBuilder: (ctx, idx) {
            final category = _categories[idx];
            return TenorCategoryWidget(
              style: _tenorStyle.categoryStyle,
              category: category,
              onTap: () =>
                  _appBarProvider.queryText = category?.searchTerm ?? '',
            );
          },
          itemCount: _categories.length,
          mainAxisSpacing: 8,
          // Add safe area padding if `TenorAttributionType.poweredBy` is disabled
          padding:
              _tabProvider.attributionType == TenorAttributionType.poweredBy
                  ? null
                  : EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
          scrollDirection: _scrollDirection,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: _crossAxisCount,
        crossAxisSpacing: 8,
        itemBuilder: (ctx, idx) => _item(_list[idx]),
        itemCount: _list.length,
        mainAxisSpacing: 8,
        // Add safe area padding if `TenorAttributionType.poweredBy` is disabled
        padding: _tabProvider.attributionType == TenorAttributionType.poweredBy
            ? null
            : EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
        scrollDirection: _scrollDirection,
      ),
    );
  }

  Widget _item(TenorResult gif) {
    final someGif = gif.media.tinygifTransparent ?? gif.media.tinygif;

    if (someGif == null) {
      return Container();
    }

    return GestureDetector(
      onTap: () => _selectedGif(gif),
      child: ExtendedImage.network(
        someGif.url,
        cache: true,
        gaplessPlayback: true,
        fit: BoxFit.fill,
        headers: const {'accept': 'image/*'},
        loadStateChanged: (state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: case2(
            state.extendedImageLoadState,
            {
              LoadState.loading: AspectRatio(
                aspectRatio: someGif.aspectRatio,
                child: Container(
                  color: Theme.of(context).cardColor,
                ),
              ),
              LoadState.completed: AspectRatio(
                aspectRatio: someGif.aspectRatio,
                child: ExtendedRawImage(
                  fit: BoxFit.fill,
                  image: state.extendedImageInfo?.image,
                ),
              ),
              LoadState.failed: AspectRatio(
                aspectRatio: someGif.aspectRatio,
                child: Container(
                  color: Theme.of(context).cardColor,
                ),
              ),
            },
            AspectRatio(
              aspectRatio: someGif.aspectRatio,
              child: Container(
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadCatagories() async {
    final fromTenor = await client.categories();

    final trendingGifResponse = await client.featured(limit: 1);
    final trendingGif = trendingGifResponse?.results.first;
    if (trendingGif != null) {
      fromTenor.insert(
        0,
        TenorCategory(
          name: 'Trending GIFs',
          searchTerm: 'Trending GIFs',
          image: trendingGif.media.tinygif?.url ?? '',
          path: 'some-url',
        ),
      );
    }

    setState(() {
      _categories = fromTenor;
    });
  }

  Future<void> _loadMore() async {
    // return if is loading or no more gifs
    if (_isLoading || _collection?.next == '') {
      return;
    }

    print('ALEX_DEBUG ${_appBarProvider.queryText}');

    _isLoading = true;

    // Offset pagination for query
    if (_collection == null) {
      offset = null;
    } else {
      // _collection.next
      offset = _collection?.next;
    }

    // If query text is not null search gif else trendings
    if (_appBarProvider.queryText.isNotEmpty) {
      if (widget.type == TenorType.emoji) {
        _collection = await client.search(
          'emoji',
          mediaFilter: const [TenorMediaFormat.tinygifTransparent],
          pos: offset,
          limit: _limit,
          sticker: true,
        );
      } else if (widget.type == TenorType.stickers) {
        _collection = await client.search(
          _appBarProvider.queryText,
          mediaFilter: const [TenorMediaFormat.tinygifTransparent],
          pos: offset,
          limit: _limit,
          sticker: true,
        );
      } else {
        _collection = await client.search(
          _appBarProvider.queryText,
          pos: offset,
          limit: _limit,
        );
      }
    } else if (widget.type == TenorType.emoji) {
      _collection = await client.search(
        'emoji',
        pos: offset,
        limit: _limit,
        mediaFilter: const [TenorMediaFormat.tinygifTransparent],
        sticker: true,
      );
    } else if (widget.type == TenorType.stickers) {
      _collection = await client.featured(
        pos: offset,
        mediaFilter: const [TenorMediaFormat.tinygifTransparent],
        sticker: true,
      );
    } else {
      // don't hit the api if we are showing categories
      if (widget.showCategories) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // otherwise get the featured gifs when no search query
      _collection = await client.featured(
        limit: _limit,
        pos: offset,
      );
    }

    // Set result to list
    if (_collection!.results.isNotEmpty && mounted) {
      setState(() {
        _list.addAll(_collection!.results);
      });
    }

    _isLoading = false;
  }

  // Scroll listener. if scroll end load more gifs
  void _scrollListener() {
    if (_appBarProvider.queryText != '' || widget.showCategories == false) {
      if (scrollController.positions.last.extentAfter.lessThan(500) &&
          !_isLoading) {
        _loadMore();
      }
    }
  }

  // Return selected gif
  void _selectedGif(TenorResult gif) {
    Navigator.pop(context, gif);
  }

  // listener query
  void _listenerQuery() {
    // Reset pagination
    _collection = null;

    // Reset list
    _list = [];

    // Load data
    _loadMore();
  }

  TValue? case2<TOptionType, TValue>(
    TOptionType selectedOption,
    Map<TOptionType, TValue> branches, [
    TValue? defaultValue,
  ]) {
    if (!branches.containsKey(selectedOption)) {
      return defaultValue;
    }

    return branches[selectedOption];
  }
}
