import 'package:dartz/dartz.dart';
import 'package:todo_app/app/usecase/usecase.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';
import 'package:todo_app/domain/repositories/common_repo.dart';
import 'package:todo_app/service_locator.dart';


class AddTaskUsecase implements UseCase<Either, ToDoModelClass> {
  @override
  Future<Either> call({ToDoModelClass? params}) {
    return sl<AddTaskRepo>().addTask(params!);
  }
}
