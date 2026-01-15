import 'package:flutter/widgets.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorAppBarProvider with ChangeNotifier {
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  String _queryText = '';
  String get queryText => _queryText;
  String _previousQueryText = '';
  String get previousQueryText => _previousQueryText;
  TenorCategory? _selectedCategory;

  Duration _debounce = Duration.zero;
  Duration get debounce => _debounce;

  set queryText(String queryText) {
    _previousQueryText = _queryText;
    _queryText = queryText;
    // reset selected category
    if (_queryText.isEmpty) {
      _selectedCategory = null;
    }
    notifyListeners();
  }

  TenorAppBarProvider(
    String queryText,
    Duration debounce, {
    required this.keyboardDismissBehavior,
    TenorCategory? selectedCategory,
  }) : _selectedCategory = selectedCategory,
       super() {
    _queryText = queryText;
    _debounce = debounce;
  }

  TenorCategory? get selectedCategory => _selectedCategory;
  set selectedCategory(TenorCategory? newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }
}
