import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AppConfig extends InheritedWidget {
  AppConfig({
    required this.appName,
    required this.debugTag,
    required this.flavorName,
    required this.initialRoute,
    required Widget child,
    required this.navigatorKey,

  }) : super(child: child);

  final String appName;
  final String flavorName;
  
  final String initialRoute;
  final bool debugTag;
  final GlobalKey navigatorKey; // Assign the navigator key here

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
