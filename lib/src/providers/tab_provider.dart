import 'package:flutter/widgets.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorTabProvider with ChangeNotifier {
  String? searchText;
  Tenor client;
  TenorAttributionType attributionType;

  TenorTabProvider({
    this.searchText,
    required this.client,
    required this.attributionType,
  });
}
