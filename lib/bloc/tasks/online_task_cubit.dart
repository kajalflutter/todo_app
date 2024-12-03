import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/failure/failure.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';
import 'package:todo_app/data/models/todo_response_modal.dart';
import 'package:todo_app/domain/usecases/add_task_usecase.dart';
import 'package:todo_app/domain/usecases/delete_task_usecase.dart';
import 'package:todo_app/domain/usecases/update_task_usecase.dart';
import 'package:todo_app/service_locator.dart';

abstract class OnlineTaskState {}

class OnlineTaskInitial extends OnlineTaskState {}

class OnlineTaskLoading extends OnlineTaskState {}

class OnlineTaskAdded extends OnlineTaskState {
  final ToDoModelClass taskRequest;
  final TaskResponse taskResponse;
  OnlineTaskAdded({required this.taskResponse, required this.taskRequest});
}

class OnlineTaskUpdated extends OnlineTaskState {
  final ToDoModelClass taskRequest;
  final TaskResponse taskResponse;
  OnlineTaskUpdated({required this.taskResponse, required this.taskRequest});
}

class OnlineTaskDeleted extends OnlineTaskState {
  final ToDoModelClass taskRequest;
  final TaskResponse taskResponse;
  OnlineTaskDeleted({required this.taskResponse, required this.taskRequest});
}

class OnlineTaskErrorState extends OnlineTaskState {
  final Failure failure;
  OnlineTaskErrorState(this.failure);
}

class OnlineTaskLoaded extends OnlineTaskState {
  final List<ToDoModelClass> tasks;
  OnlineTaskLoaded(this.tasks);
}

class OnlineTaskCubit extends Cubit<OnlineTaskState> {
  OnlineTaskCubit() : super(OnlineTaskInitial());
  Future<void> addTask(ToDoModelClass toDoModel) async {
    emit(OnlineTaskLoading());
    var response = await sl<AddTaskUsecase>().call(params: toDoModel);
    response.fold((l) {
      emit(OnlineTaskErrorState(l));
    }, (r) {
      emit(OnlineTaskAdded(taskResponse: r, taskRequest: toDoModel));
    });
  }

  Future<void> updateTask(ToDoModelClass toDoModel) async {
    emit(OnlineTaskLoading());
    var response = await sl<UpdateTaskUsecase>().call(params: toDoModel);
    response.fold((l) {
      emit(OnlineTaskErrorState(l));
    }, (r) {
      emit(OnlineTaskUpdated(taskResponse: r, taskRequest: toDoModel));
    });
  }

  Future<void> deleteTask(ToDoModelClass toDoModel) async {
    emit(OnlineTaskLoading());
    var response = await sl<DeleteTaskUsecase>().call(params: toDoModel);
    response.fold((l) {
      emit(OnlineTaskErrorState(l));
    }, (r) {
      emit(OnlineTaskDeleted(taskResponse: r, taskRequest: toDoModel));
    });
  }

  @override
  Future<void> close() async {
    //cancel streams
    super.close();
  }
}
