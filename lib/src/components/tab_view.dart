// TODO: Not super happy with how categories exist in this file. Refactor in the future.
// ignore_for_file: implementation_imports
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tenor_flutter/src/components/components.dart';
import 'package:tenor_flutter/src/providers/app_bar_provider.dart';
import 'package:tenor_flutter/src/providers/tab_provider.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

const featuredCategoryPath = '##trending-gifs';

class TenorTabViewStyle {
  final Color mediaBackgroundColor;

  const TenorTabViewStyle({
    this.mediaBackgroundColor = Colors.white,
  });
}

class TenorTabView extends StatefulWidget {
  final Widget Function(BuildContext, Widget?)? builder;
  final TenorCategoryStyle categoryStyle;
  final Tenor client;
  final String featuredCategory;
  final int mediaWidth;
  final bool? keepAliveTabView;
  final Future<TenorResponse?> Function(
    String queryText,
    String? pos,
    int limit,
    TenorCategory? category,
  )? onLoad;
  final Function(TenorResult? gif)? onSelected;
  final bool showCategories;
  final TenorTabViewStyle style;

  const TenorTabView({
    required this.client,
    required this.mediaWidth,
    this.builder,
    this.categoryStyle = const TenorCategoryStyle(),
    String? featuredCategory,
    this.keepAliveTabView,
    this.onLoad,
    this.onSelected,
    this.showCategories = false,
    this.style = const TenorTabViewStyle(),
    super.key,
  }) : featuredCategory = featuredCategory ?? '📈 Featured';

  @override
  State<TenorTabView> createState() => _TenorTabViewState();
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
    scrollController.addListener(_scrollListener);

    // AppBar Provider
    _appBarProvider = Provider.of<TenorAppBarProvider>(context, listen: false);
    _appBarProvider.addListener(_listenerQuery);

    // Tab Provider
    _tabProvider = Provider.of<TenorTabProvider>(context, listen: false);

    // setup client
    client = widget.client;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCount();
      // load categories
      if (widget.showCategories) {
        _loadCatagories();
      }
      // load gifs if the query text starts populated or if show categories is disabled
      if (_appBarProvider.queryText != '' || widget.showCategories == false) {
        _loadGifs();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getCount();

    // Initial offset
    offset = null;
  }

  void getCount() {
    // Set items count responsive
    _crossAxisCount =
        (MediaQuery.of(context).size.width / widget.mediaWidth).round();

    // Set vertical max items count
    int mainAxisCount =
        ((MediaQuery.of(context).size.height - 30) / widget.mediaWidth).round();

    // Calculate the visible limit
    _limit = _crossAxisCount * mainAxisCount;

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
            shrinkWrap: true,
            controller: scrollController,
            crossAxisCount: _crossAxisCount,
            crossAxisSpacing: 8,
            keyboardDismissBehavior: _appBarProvider.keyboardDismissBehavior,
            itemBuilder: (ctx, idx) {
              final category = _categories[idx];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TenorCategoryWidget(
                  style: widget.categoryStyle,
                  category: category,
                  onTap: (selectedCategory) {
                    if (selectedCategory.path.startsWith('##') == false) {
                      // if it's a normal category, search it up
                      _appBarProvider.queryText = selectedCategory.searchTerm;
                    } else {
                      // otherwise just set it so we can make a custom view
                      _appBarProvider.selectedCategory = selectedCategory;
                    }
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
        shrinkWrap: true,
        crossAxisCount: _crossAxisCount,
        crossAxisSpacing: 8,
        keyboardDismissBehavior: _appBarProvider.keyboardDismissBehavior,
        itemBuilder: (ctx, idx) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TenorSelectableGif(
            backgroundColor: widget.style.mediaBackgroundColor,
            onTap: (selectedResult) => _selectedGif(
              selectedResult,
            ),
            result: _list[idx],
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

  // the reason we are loading like this and not with a predictive method
  // that calculates based on size is because iOS "Display Zoom" breaks that
  Future<void> _loadGifs() async {
    await _loadMore();

    // wait for a frame so that we can ensure that `scrollController` is attached
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      while (scrollController.position.extentAfter == 0) {
        await _loadMore();
      }
    });
  }

  Future<void> _loadCatagories() async {
    try {
      final fromTenor = await client.categories();
      final featuredGifResponse = await client.featured(limit: 1);
      final featuredGif = featuredGifResponse?.results.first;
      if (featuredGif != null) {
        fromTenor.insert(
          0,
          TenorCategory(
            image: featuredGif.media.tinyGif?.url ?? '',
            name: widget.featuredCategory,
            path: featuredCategoryPath,
            searchTerm: 'featured',
          ),
        );
      }

      setState(() {
        _categories = fromTenor;
      });
    } catch (e) {
      //
    }
  }

  Future<void> _loadMore() async {
    try {
      // return if loading
      if (_isLoading) return;

      // failsafe if categories are empty when we load more (network issues)
      if (widget.showCategories && _categories.isEmpty) {
        _loadCatagories();
      }

      // return no more gifs
      if (_collection?.next == '') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      _isLoading = true;

      // Offset pagination for query
      if (_collection == null) {
        offset = null;
      } else {
        // _collection.next
        offset = _collection!.next;
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

      if (_appBarProvider.queryText == '') {
        ///
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
    } on TenorNetworkException {
      _isLoading = false;
    } on TenorApiException {
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      rethrow;
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
    try {
      // https://developers.google.com/tenor/guides/endpoints#register-share
      client.registerShare(gif.id, search: _appBarProvider.queryText);
    } catch (e) {
      // do nothing if it fails
    }
    // return result to the consumer
    Navigator.pop(context, gif);
  }

  // listener query
  void _listenerQuery() {
    // Reset pagination
    _collection = null;

    // Reset list
    _list = [];

    if (_isLoading) return;

    // Load data
    _loadGifs();
  }
}
