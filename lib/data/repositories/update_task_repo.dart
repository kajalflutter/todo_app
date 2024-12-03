import 'package:dartz/dartz.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';
import 'package:todo_app/data/sources/update_task_service.dart';
import 'package:todo_app/domain/repositories/common_repo.dart';
import 'package:todo_app/service_locator.dart';

class UpdateTaskRepoImpl extends UpdateTaskRepo {
  @override
  Future<Either> updateTask(ToDoModelClass taskRequest) async {
    return await sl<UpdateTaskService>().updateTask(taskRequest);
  }
}
