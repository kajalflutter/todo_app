import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:todo_app/app/api_manager.dart';
import 'package:todo_app/app/app_api.dart';
import 'package:todo_app/data/failure/error_handler.dart';
import 'package:todo_app/data/failure/failure.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';
import 'package:todo_app/data/models/todo_response_modal.dart';

abstract class DeleteTaskService {
  Future<Either> deleteTask(ToDoModelClass taskRequest);
}

class DeleteTaskServiceImpl extends DeleteTaskService {
  final ApiService _apiService = ApiService();
  @override
  Future<Either<Failure, TaskResponse>> deleteTask(ToDoModelClass taskRequest) async {
    try {
      var data = taskRequest;
      Response response = await _apiService.delete(APIManager.deleteTask + taskRequest.taskNo.toString(),
          data: data.toDoModelClassMap());
      TaskResponse taskResponse = TaskResponse.fromJson(response.data);
      return Right(taskResponse);
    } catch (error) {
      final handler = ErrorHandler.handle(error);
      return Left(handler.failure);
    }
  }
}
