import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';
import 'package:todo_app/database_helper.dart';

// State Class
abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoaded extends TaskState {
  final List<ToDoModelClass> tasks;
  TaskLoaded(this.tasks);
}

class TaskAdded extends TaskState {
  final int taskId;
  final ToDoModelClass toDoModelClass;
  TaskAdded(this.taskId, this.toDoModelClass);
}

class TaskDeleted extends TaskState {
  final ToDoModelClass toDoModelClass;
  TaskDeleted(this.toDoModelClass);
}

class TaskUpdated extends TaskState {
  final ToDoModelClass toDoModelClass;
  TaskUpdated(this.toDoModelClass);
}

// Cubit Class

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  List<ToDoModelClass> _tasks = [];

  DatabaseHelper db = DatabaseHelper();

  Future<void> getTasks() async {
    db.initializeDB();
    _tasks = await db.getTaskList();
    emit(TaskLoaded(_tasks));
  }

  Future<void> addTask(ToDoModelClass task) async {
    int taskId = await db.insertTask(
      ToDoModelClass(
          title: task.title!.trim(),
          description: task.description!.trim(),
          date: task.date,
          updatedDate: task.updatedDate),
    );
    if (!task.isSynced) {
      emit(TaskAdded(taskId, task));
    }
  }

  Future<void> editTask(ToDoModelClass updatedTask) async {
    await db.updateTask(updatedTask);
    if (!updatedTask.isSynced) {
      emit(TaskUpdated(updatedTask));
    }
  }

  Future<void> removeTask(ToDoModelClass deleteTask) async {
    await db.deleteTask(deleteTask);
    emit(TaskDeleted(deleteTask));
    //getTasks();
  }

  Future<void> toggleTaskCompletion(ToDoModelClass updatedTask) async {
    updatedTask.completed = !updatedTask.completed;
    await db.updateTask(updatedTask);
    getTasks();
  }
}
