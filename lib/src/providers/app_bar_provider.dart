import 'package:flutter/widgets.dart';

class TenorAppBarProvider with ChangeNotifier {
  String _queryText = '';
  String get queryText => _queryText;

  int _debounceTimeInMilliseconds = 0;
  int get debounceTimeInMilliseconds => _debounceTimeInMilliseconds;

  set queryText(String queryText) {
    _queryText = queryText;
    notifyListeners();
  }

  TenorAppBarProvider(String queryText, int debounceTimeInMilliseconds) {
    _queryText = queryText;
    _debounceTimeInMilliseconds = debounceTimeInMilliseconds;
  }

  @override
  // ignore: must_call_super
  void dispose() {
    print("Dispose TenorAppBarProvider");
  }
}
