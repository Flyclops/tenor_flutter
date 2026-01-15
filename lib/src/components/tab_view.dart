// TODO: Not super happy with how categories exist in this file. Refactor in the future.
// ignore_for_file: implementation_imports
import 'package:extended_image/extended_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
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
  final int gifsPerRow;
  final bool? keepAliveTabView;
  final Future<TenorResponse?> Function(
    String queryText,
    String? pos,
    int limit,
    TenorCategory? category,
  )?
  onLoad;
  final Function(TenorResult? gif)? onSelected;
  final bool showCategories;
  final TenorTabViewStyle style;

  const TenorTabView({
    required this.client,
    this.builder,
    this.categoryStyle = const TenorCategoryStyle(),
    String? featuredCategory,
    int? gifsPerRow,
    this.keepAliveTabView,
    this.onLoad,
    this.onSelected,
    this.showCategories = false,
    this.style = const TenorTabViewStyle(),
    super.key,
  }) : featuredCategory = featuredCategory ?? '📈 Featured',
       gifsPerRow = gifsPerRow ?? 3;

  @override
  State<TenorTabView> createState() => _TenorTabViewState();
}

class _TenorTabViewState extends State<TenorTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.keepAliveTabView ?? true;

  // Tab Provider
  late TenorTabProvider _tabProvider;

  // Scroll Controller
  late final ScrollController _scrollController;

  // AppBar Provider
  late TenorAppBarProvider _appBarProvider;

  // Collection
  TenorResponse? _collection;

  // List of gifs
  List<TenorResult> _list = [];

  // Direction
  final Axis _scrollDirection = Axis.vertical;

  // State to tell us if we are currently loading gifs.
  bool _isLoading = false;

  /// State to tell us if we can request more gifs.
  bool _hasMoreGifs = true;

  // Offset
  String? offset;

  List<TenorCategory?> _categories = [];

  /// The Tenor client so we can use the API.
  late final Tenor client;

  /// The current tabs data.
  late final TenorTab tab;

  /// The limit of gifs to request per load.
  late int requestLimit;

  @override
  void initState() {
    super.initState();
    // Setup client
    client = widget.client;

    // Which tab are we?
    tab = context.read<TenorTab>();

    // We should update this whenever the size changes eventually
    requestLimit = _calculateLimit();

    // AppBar Provider
    _appBarProvider = Provider.of<TenorAppBarProvider>(context, listen: false);
    _appBarProvider.addListener(_appBarProviderListener);

    // Scroll Controller
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollControllerListener);

    // Tab Provider
    _tabProvider = Provider.of<TenorTabProvider>(context, listen: false);
    _tabProvider.addListener(_tabProviderListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // load categories
      if (widget.showCategories) {
        _loadCatagories();
      }
      // load gifs if the query text starts populated or if show categories is disabled
      if (_appBarProvider.queryText != '' || widget.showCategories == false) {
        _initialGifFetch();
      }
    });
  }

  @override
  void dispose() {
    _appBarProvider.removeListener(_appBarProviderListener);
    _scrollController.removeListener(_scrollControllerListener);
    _tabProvider.removeListener(_tabProviderListener);
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

    if (_appBarProvider.queryText.trim().isEmpty &&
        _appBarProvider.selectedCategory == null &&
        widget.showCategories) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: MasonryGridView.count(
            shrinkWrap: true,
            controller: _scrollController,
            crossAxisCount: widget.gifsPerRow,
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
        controller: _scrollController,
        shrinkWrap: true,
        crossAxisCount: widget.gifsPerRow,
        crossAxisSpacing: 8,
        keyboardDismissBehavior: _appBarProvider.keyboardDismissBehavior,
        itemBuilder:
            (ctx, idx) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TenorSelectableGif(
                backgroundColor: widget.style.mediaBackgroundColor,
                onTap: (selectedResult) => _selectedGif(selectedResult),
                result: _list[idx],
              ),
            ),
        itemCount: _list.length,
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

  // Estimate the request limit based on the visible area. Doesn't need to be precise.
  // This function assumes all gifs are 1:1 aspect ratio for simplicity.
  int _calculateLimit() {
    // Tenor has a hard limit of 50 per request
    const int tenorRequestLimit = 50;
    // Call this here so we get updated constraints in case of size change
    final constraints = context.read<BoxConstraints>();
    // The width of each gif (estimated)
    final gifWidth = constraints.maxWidth / widget.gifsPerRow;
    // How many rows of gifs can fit on the screen (estimated)
    final gifRowCount = (constraints.maxHeight / gifWidth).round();
    // Based on estimates, how many gifs can we fit into the TabView
    final calculatedRequestLimit = widget.gifsPerRow * gifRowCount;
    // If the limit is greater than Tenor's hard limit, cap it
    return calculatedRequestLimit > tenorRequestLimit
        ? tenorRequestLimit
        : calculatedRequestLimit;
  }

  // Load an initial batch of gifs and then attempt to load more until the list
  // is full by checking if there is a scrollable area. The reason we are loading
  // like this and not with a predictive method that calculates based on size is
  // because iOS "Display Zoom" breaks that.
  Future<void> _initialGifFetch() async {
    // Prevent non active tabs from loading more
    if (_tabProvider.selectedTab != tab) return;

    // Do not fetch when categories are visible
    if (widget.showCategories &&
        _appBarProvider.queryText.isEmpty &&
        _appBarProvider.selectedCategory == null) {
      return;
    }

    // Load some gifs so that the ScrollController can become attached
    if (_list.isEmpty) {
      await _loadMore();
    }

    // Wait for a frame so that we can ensure that `scrollController` is attached
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_scrollController.position.extentAfter == 0) {
        _loadMore(fillScrollableArea: true);
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

  Future<void> _loadMore({bool fillScrollableArea = false}) async {
    // 1 - prevent non active tabs from loading more
    // 2 - if it's loading don't load more
    // 3 - if there are no more gifs to load, don't load more
    if (_tabProvider.selectedTab != tab || _isLoading || !_hasMoreGifs) return;

    try {
      // fail safe if categories are empty when we load more (network issues)
      if (widget.showCategories && _categories.isEmpty) {
        _loadCatagories();
      }

      // api says there are no more gifs, so lets stop requesting
      if (_collection?.next == '') {
        setState(() {
          _hasMoreGifs = false;
        });
        return;
      }

      _isLoading = true;

      // Offset pagination for query
      if (_collection == null) {
        offset = null;
      } else {
        offset = _collection!.next;
      }

      if (widget.onLoad != null) {
        final response = await widget.onLoad?.call(
          _appBarProvider.queryText.trim(),
          offset,
          requestLimit,
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
    } on TenorNetworkException {
      _isLoading = false;
    } on TenorApiException {
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      rethrow;
    }

    if (fillScrollableArea && _scrollController.position.extentAfter == 0) {
      Future.microtask(() => _loadMore(fillScrollableArea: true));
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
    Navigator.pop(
      context,
      gif.copyWith(
        source: _tabProvider.selectedTab.name,
      ),
    );
  }

  // if you scroll within a threshhold of the bottom of the screen, load more gifs
  void _scrollControllerListener() {
    // trending-gifs, etc
    final customCategorySelected =
        _appBarProvider.selectedCategory != null &&
        _appBarProvider.queryText == '';

    if (customCategorySelected ||
        _appBarProvider.queryText != '' ||
        widget.showCategories == false) {
      if (_scrollController.positions.last.extentAfter.lessThan(500) &&
          !_isLoading) {
        _loadMore();
      }
    }
  }

  // When the text in the search input changes
  void _appBarProviderListener() {
    final queryText = _appBarProvider.queryText;
    final trimmedQueryText = _appBarProvider.queryText.trim();
    final trimmedPreviousQueryText = _appBarProvider.previousQueryText.trim();

    // do nothing if the text did not change
    if (trimmedQueryText == trimmedPreviousQueryText) return;

    // Prevent searches with only spaces
    if (queryText.isNotEmpty && trimmedQueryText.isEmpty) return;

    setState(() {
      _list = [];
      _collection = null;
      _hasMoreGifs = true;
    });

    _initialGifFetch();
  }

  /// When new tab is loaded into view
  void _tabProviderListener() {
    _initialGifFetch();
  }
}
