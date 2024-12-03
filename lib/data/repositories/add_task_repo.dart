import 'package:dartz/dartz.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';
import 'package:todo_app/data/sources/add_task_service.dart';
import 'package:todo_app/domain/repositories/common_repo.dart';
import 'package:todo_app/service_locator.dart';

class AddTaskRepoImpl extends AddTaskRepo {
  @override
  Future<Either> addTask(ToDoModelClass taskRequest) async {
    return await sl<AddTaskService>().addTask(taskRequest);
  }
}
