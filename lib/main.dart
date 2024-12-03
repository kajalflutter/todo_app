import 'package:flutter/material.dart';
import 'package:todo_app/app/router.dart';
import 'package:todo_app/service_locator.dart';
import 'app/app_config.dart';
import 'my_app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  MyApp.initSystemDefault();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  runApp(
    AppConfig(
      appName: "TODO",
      navigatorKey: navigatorKey,
      debugTag: false,
      flavorName: "dev",
      initialRoute: AppRouter.taskRoute,
      child: MyApp.runWidget(),
    ),
  );
}
