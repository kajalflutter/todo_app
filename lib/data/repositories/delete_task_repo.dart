import 'package:dartz/dartz.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';
import 'package:todo_app/data/sources/delete_task_service.dart';
import 'package:todo_app/domain/repositories/common_repo.dart';
import 'package:todo_app/service_locator.dart';

class DeleteTaskRepoImpl extends DeleteTaskRepo {
  @override
  Future<Either> deleteTask(ToDoModelClass taskRequest) async {
    return await sl<DeleteTaskService>().deleteTask(taskRequest);
  }
}
