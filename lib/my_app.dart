import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/app/router.dart';
import 'package:todo_app/app/theme/app_theme.dart';
import 'package:todo_app/bloc/connectivity_cubit.dart';
import 'package:todo_app/bloc/tasks/online_task_cubit.dart';
import 'package:todo_app/bloc/tasks/task_cubit.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/presentation/screens/todo_app_ui.dart';
import 'app/app_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/simple_bloc_observer.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskCubit(),
        ),
        BlocProvider(
          create: (context) => ConnectivityCubit(),
        ),
        BlocProvider(
          create: (context) => OnlineTaskCubit(),
        )
      ],
      child: const MyMainApp(),
    );
  }

  static void initSystemDefault() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.red,
      ),
    );
  }

  static Widget runWidget() {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = SimpleBlocObserver();
    return MyApp();
  }
}

class MyMainApp extends StatelessWidget {
  const MyMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context)!;

    ConnectivityState? previousState;
    return BlocListener<ConnectivityCubit, ConnectivityState>(
      listener: (context, state) {
        if (state == ConnectivityState.connected) {
          if (previousState != null &&
              (previousState == ConnectivityState.disconnected ||
                  previousState == ConnectivityState.noInternet ||
                  previousState == ConnectivityState.unknown)) {
            print("Internet Connected");
            //sync data with backend if data isnt synced
          }
        }
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: config.debugTag,
          onGenerateRoute: AppRouter.generateRoute,
          home: const TODOAppUI(),
          theme: AppTheme.lightTheme),
    );
  }
}
