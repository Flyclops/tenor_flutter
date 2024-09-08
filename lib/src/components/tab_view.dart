// ignore_for_file: implementation_imports
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tenor_flutter/src/components/components.dart';
import 'package:tenor_flutter/src/components/selectable_gif.dart';
import 'package:tenor_flutter/src/models/attribution.dart';
import 'package:tenor_flutter/src/providers/app_bar_provider.dart';
import 'package:tenor_flutter/src/providers/tab_provider.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

const featuredCategoryPath = '##trending-gifs';

class TenorTabViewStyle {
  const TenorTabViewStyle();
}

class TenorTabView extends StatefulWidget {
  final Function(TenorResult? gif)? onSelected;
  final bool showCategories;
  final bool? keepAliveTabView;
  final int gifWidth;
  final TenorCategoryStyle categoryStyle;
  final Tenor client;
  final Future<TenorResponse?> Function(
    String queryText,
    String? pos,
    int limit,
    TenorCategory? category,
  )? onLoad;
  // final Function? initialLoad;

  final Widget Function(BuildContext, Widget?)? builder;

  const TenorTabView({
    required this.gifWidth,
    required this.client,
    this.showCategories = false,
    this.onSelected,
    this.keepAliveTabView,
    this.categoryStyle = const TenorCategoryStyle(),
    this.onLoad,
    this.builder,
    Key? key,
  }) : super(key: key);

  @override
  _TenorTabViewState createState() => _TenorTabViewState();
}

class _TenorTabViewState extends State<TenorTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.keepAliveTabView ?? true;

  // Tab Provider
  late TenorTabProvider _tabProvider;

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

    // AppBar Provider
    _appBarProvider = Provider.of<TenorAppBarProvider>(context, listen: false);

    // Tab Provider
    _tabProvider = Provider.of<TenorTabProvider>(context, listen: false);

    // setup client
    client = widget.client;

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

    if (_appBarProvider.queryText.isEmpty &&
        _appBarProvider.selectedCategory == null &&
        widget.showCategories) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: MasonryGridView.count(
            controller: scrollController,
            crossAxisCount: _crossAxisCount,
            crossAxisSpacing: 8,
            itemBuilder: (ctx, idx) {
              final category = _categories[idx];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TenorCategoryWidget(
                  style: widget.categoryStyle,
                  category: category,
                  onTap: (selectedCategory) {
                    // if it's a normal category, search it up
                    if (selectedCategory.path.startsWith('##') == false) {
                      _appBarProvider.queryText = selectedCategory.searchTerm;
                    }
                    // otherwise just set it so we can make a custom view
                    _appBarProvider.selectedCategory = selectedCategory;
                  },
                ),
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
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: _crossAxisCount,
        crossAxisSpacing: 8,
        itemBuilder: (ctx, idx) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TenorSelectableGif(
            result: _list[idx],
            onTap: (selectedResult) => _selectedGif(
              selectedResult,
            ),
          ),
        ),
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

  Future<void> _loadCatagories() async {
    final fromTenor = await client.categories();

    final featuredGifResponse = await client.featured(limit: 1);
    final featuredGif = featuredGifResponse?.results.first;
    if (featuredGif != null) {
      fromTenor.insert(
        0,
        TenorCategory(
          name: 'Featured',
          searchTerm: '📈 Featured',
          image: featuredGif.media.tinygif?.url ?? '',
          path: featuredCategoryPath,
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

    _isLoading = true;

    // Offset pagination for query
    if (_collection == null) {
      offset = null;
    } else {
      // _collection.next
      offset = _collection?.next;
    }

    if (widget.onLoad != null) {
      final response = await widget.onLoad?.call(
        _appBarProvider.queryText,
        offset,
        _limit,
        _appBarProvider.selectedCategory,
      );
      if (response != null) {
        _collection = response;
      }
    }

    // Set result to list
    if (_collection != null && _collection!.results.isNotEmpty && mounted) {
      setState(() {
        _list.addAll(_collection!.results);
        _isLoading = false;
      });
    } else {
      // so it refreshes on something like categories
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Scroll listener. if scroll end load more gifs
  void _scrollListener() {
    // trending-gifs, etc
    final customCategorySelected = _appBarProvider.selectedCategory != null &&
        _appBarProvider.queryText == '';

    if (customCategorySelected ||
        _appBarProvider.queryText != '' ||
        widget.showCategories == false) {
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
    print('ALEX_DEBUG _listenerQuery');
    // Reset pagination
    _collection = null;

    // Reset list
    _list = [];

    // Load data
    _loadMore();
  }
}