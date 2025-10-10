import 'package:flutter/widgets.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorTabProvider with ChangeNotifier {
  String? tabSelection;
  Tenor client;
  TenorAttributionType attributionType;

  TenorTabProvider({
    required this.client,
    required this.attributionType,
    this.tabSelection,
  });
}
