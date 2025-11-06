import 'package:flutter/material.dart';

// Finding out if the device is a tablet by checking the shortest side of the device
bool isTablet(BuildContext context) {
  return MediaQuery.of(context).size.shortestSide > 600;
}
