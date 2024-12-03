import 'package:flutter/material.dart';
import 'package:todo_app/presentation/screens/todo_app_ui.dart';

class AppRouter {
  static const String taskRoute = '/';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case taskRoute:
        return MaterialPageRoute(builder: (_) => const TODOAppUI());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
