import 'package:get_it/get_it.dart';
import 'package:todo_app/data/repositories/add_task_repo.dart';
import 'package:todo_app/data/repositories/delete_task_repo.dart';
import 'package:todo_app/data/repositories/update_task_repo.dart';
import 'package:todo_app/data/sources/add_task_service.dart';
import 'package:todo_app/data/sources/delete_task_service.dart';
import 'package:todo_app/data/sources/update_task_service.dart';
import 'package:todo_app/domain/repositories/common_repo.dart';
import 'package:todo_app/domain/usecases/add_task_usecase.dart';
import 'package:todo_app/domain/usecases/delete_task_usecase.dart';
import 'package:todo_app/domain/usecases/update_task_usecase.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  sl.registerSingleton<DeleteTaskUsecase>(DeleteTaskUsecase());
  sl.registerSingleton<DeleteTaskRepo>(DeleteTaskRepoImpl());
  sl.registerSingleton<DeleteTaskService>(DeleteTaskServiceImpl());
  sl.registerSingleton<AddTaskUsecase>(AddTaskUsecase());
  sl.registerSingleton<AddTaskRepo>(AddTaskRepoImpl());
  sl.registerSingleton<AddTaskService>(AddTaskServiceImpl());
  sl.registerSingleton<UpdateTaskUsecase>(UpdateTaskUsecase());
  sl.registerSingleton<UpdateTaskRepo>(UpdateTaskRepoImpl());
  sl.registerSingleton<UpdateTaskService>(UpdateTaskServiceImpl());
}
