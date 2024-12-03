import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/data/failure/error_handler.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/domain/usecases/add_task_usecase.dart';
import 'package:todo_app/domain/usecases/delete_task_usecase.dart';
import 'package:todo_app/service_locator.dart';

enum ConnectivityState { connected, disconnected, unknown, noInternet }

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityCubit()
      : _connectivity = Connectivity(),
        super(ConnectivityState.unknown) {
    _monitorConnection();
  }

  void _monitorConnection() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) async {
      if (result.last == ConnectivityResult.mobile || result.last == ConnectivityResult.wifi) {
        final hasInternet = await _checkInternetAccess();
        if (hasInternet) {
          emit(ConnectivityState.connected);
          await _syncLocalData(); // Trigger sync when connected

          print("Internet Connected");
        } else {
          emit(ConnectivityState.noInternet);
          print("not Connected");
        }
      } else {
        emit(ConnectivityState.disconnected);
        print("not Connected");
      }
    });
  }

  Future<bool> _checkInternetAccess() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 120)); // Timeout after 5 seconds
      if (response.statusCode == 200) {
        return true; // Internet is accessible
      } else {
        return false; // Server responded, but not a success code
      }
    } catch (_) {
      return false; // Failed to connect to the server
    }
  }

  Future<void> _syncLocalData() async {
    try {
      DatabaseHelper db = DatabaseHelper();
      final List<ToDoModelClass> unsyncedTasks = await db.getUnsyncTaskList();
      for (final task in unsyncedTasks) {
        var response = await sl<AddTaskUsecase>().call(params: task);
        response.fold((l) {
          print("Error occured for task ${task.taskNo}");
        }, (r) async {
          await db.updateTask(task.copyWith(isSynced: true));
        });
      }

      final List<ToDoModelClass> unsyncedDeleteTasks = await db.getUnsyncTaskDeleteList();
      for (final task in unsyncedDeleteTasks) {
        var response = await sl<DeleteTaskUsecase>().call(params: task);
        response.fold((l) {
          print("Error occured for task ${task.taskNo}");
        }, (r) async {
          await db.deleteTableUpdate(task);
        });
      }
    } catch (e) {
      print("Error syncing data: $e");
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
