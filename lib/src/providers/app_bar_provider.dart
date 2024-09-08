import 'package:flutter/widgets.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorAppBarProvider with ChangeNotifier {
  String _queryText = '';
  String get queryText => _queryText;
  TenorCategory? _selectedCategory;

  int _debounceTimeInMilliseconds = 0;
  int get debounceTimeInMilliseconds => _debounceTimeInMilliseconds;

  set queryText(String queryText) {
    _queryText = queryText;
    // reset selected category
    if (_queryText.isEmpty) {
      _selectedCategory = null;
    }
    notifyListeners();
  }

  TenorAppBarProvider(
    String queryText,
    int debounceTimeInMilliseconds, {
    TenorCategory? selectedCategory,
  })  : _selectedCategory = selectedCategory,
        super() {
    _queryText = queryText;
    _debounceTimeInMilliseconds = debounceTimeInMilliseconds;
  }

  TenorCategory? get selectedCategory => _selectedCategory;
  set selectedCategory(TenorCategory? newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }
}
