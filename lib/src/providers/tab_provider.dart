import 'package:flutter/widgets.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorTabProvider with ChangeNotifier {
  TenorAttributionType attributionType;
  Tenor client;
  String selectedTab;

  TenorTabProvider({
    required this.attributionType,
    required this.client,
    required this.selectedTab,
  });
}
