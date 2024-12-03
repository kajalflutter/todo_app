import 'package:dartz/dartz.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';

abstract class AddTaskRepo {
  Future<Either> addTask(ToDoModelClass taskRequest);
}

abstract class UpdateTaskRepo {
  Future<Either> updateTask(ToDoModelClass taskRequest);
}

abstract class DeleteTaskRepo {
  Future<Either> deleteTask(ToDoModelClass taskRequest);
}




