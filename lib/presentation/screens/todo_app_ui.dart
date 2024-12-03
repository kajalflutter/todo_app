import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/app/functions.dart';
import 'package:todo_app/bloc/connectivity_cubit.dart';
import 'package:todo_app/bloc/tasks/online_task_cubit.dart';
import 'package:todo_app/bloc/tasks/task_cubit.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';

class TODOAppUI extends StatefulWidget {
  const TODOAppUI({super.key});
  @override
  State<TODOAppUI> createState() => _TODOAppUIState();
}

class _TODOAppUIState extends State<TODOAppUI> with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late TaskCubit taskCubit;
  late final SlidableController _slidableController;

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
  }

  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController(this);
    taskCubit = context.read<TaskCubit>();
    taskCubit.getTasks();
  }

  @override
  void dispose() {
    super.dispose();
    _slidableController.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  List<ToDoModelClass> listTasks = [];

  void submit(bool doEdit, [ToDoModelClass? toDoModelObject]) async {
    if (titleController.text.trim().isNotEmpty && descriptionController.text.trim().isNotEmpty) {
      if (!doEdit) {
        await taskCubit.addTask(
          ToDoModelClass(
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            date: DateTime.now().toIso8601String(),
            updatedDate: DateTime.now().toIso8601String(),
          ),
        );
      } else {
        toDoModelObject!.date = DateTime.now().toIso8601String();
        toDoModelObject.title = titleController.text.trim();
        toDoModelObject.description = descriptionController.text.trim();
        toDoModelObject.isSynced = false;
        await taskCubit.editTask(toDoModelObject);
      }
    }
    clearControllers();
  }

  Future<void> showBottomSheet(bool doEdit, [ToDoModelClass? toDoModelObject]) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                doEdit ? "Edit Task" : "Create Task",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title",
                      style: GoogleFonts.quicksand(
                        color: const Color.fromRGBO(89, 57, 241, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter title";
                        } else {
                          return null;
                        }
                      },
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Enter Title",
                        contentPadding: const EdgeInsets.all(20),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(89, 57, 241, 1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Description",
                      style: GoogleFonts.quicksand(
                        color: const Color.fromRGBO(89, 57, 241, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter description";
                        } else {
                          return null;
                        }
                      },
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        hintText: "Enter Description",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(89, 57, 241, 1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: 300,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        13,
                      ),
                    ),
                    backgroundColor: const Color.fromRGBO(89, 57, 241, 1),
                  ),
                  onPressed: () {
                    bool loginValidated = _formKey.currentState!.validate();
                    if (loginValidated) {
                      doEdit ? submit(doEdit, toDoModelObject) : submit(doEdit);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      _slidableController.close(); // Close any open Slidable
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(111, 81, 255, 1),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 35),
                  child: Text(
                    "Welcome to",
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 35),
                  child: Text(
                    "Tasky",
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocConsumer<OnlineTaskCubit, OnlineTaskState>(
                  listener: (context, state) {
                    if (state is OnlineTaskAdded) {
                      context.read<TaskCubit>().editTask(
                            state.taskRequest.copyWith(isSynced: true),
                          );
                    }
                    if (state is OnlineTaskUpdated) {
                      context.read<TaskCubit>().editTask(
                            state.taskRequest.copyWith(isSynced: true),
                          );
                    }
                  },
                  builder: (context, state) {
                    return BlocConsumer<TaskCubit, TaskState>(
                      listener: (context, state) {
                        if (state is TaskLoaded) {
                          listTasks = state.tasks;
                        } else if (state is TaskAdded) {
                          showSuccessSnackBar(context, "Task Added Successfully");
                          final connectivityState = context.read<ConnectivityCubit>().state;
                          if (connectivityState == ConnectivityState.connected) {
                            context.read<OnlineTaskCubit>().addTask(
                                  state.toDoModelClass.copyWith(taskNo: state.taskId, isSynced: true),
                                );
                          }
                          taskCubit.getTasks();
                        } else if (state is TaskUpdated) {
                          showSuccessSnackBar(context, "Task Updated Successfully");
                          final connectivityState = context.read<ConnectivityCubit>().state;
                          if (connectivityState == ConnectivityState.connected) {
                            context.read<OnlineTaskCubit>().updateTask(
                                  state.toDoModelClass.copyWith(isSynced: true),
                                );
                          }
                          taskCubit.getTasks();
                        } else if (state is TaskDeleted) {
                          showSuccessSnackBar(context, "Task Deleted Successfully");
                          final connectivityState = context.read<ConnectivityCubit>().state;
                          if (connectivityState == ConnectivityState.connected) {
                            context.read<OnlineTaskCubit>().deleteTask(
                                  state.toDoModelClass.copyWith(isSynced: true),
                                );
                          }
                          taskCubit.getTasks();
                        }
                      },
                      builder: (context, state) {
                        return Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(217, 217, 217, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "MY TASKS",
                                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 20),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        topRight: Radius.circular(
                                          40,
                                        ),
                                      ),
                                    ),
                                    child: listTasks.isEmpty
                                        ? Center(
                                            child: Text("No Tasks Added",
                                                style:
                                                    GoogleFonts.quicksand(fontWeight: FontWeight.w500, fontSize: 15)))
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            //reverse: true,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index) {
                                              return Slidable(
                                                // controller: _slidableController,
                                                closeOnScroll: true,
                                                endActionPane: ActionPane(
                                                  extentRatio: 0.2,
                                                  motion: const DrawerMotion(),
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          GestureDetector(
                                                            child: Container(
                                                              padding: const EdgeInsets.all(10),
                                                              height: 40,
                                                              width: 40,
                                                              decoration: BoxDecoration(
                                                                color: const Color.fromRGBO(89, 57, 241, 1),
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              child: const Icon(
                                                                Icons.edit,
                                                                color: Colors.white,
                                                                size: 20,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              titleController.text = listTasks[index].title ?? "";
                                                              descriptionController.text =
                                                                  listTasks[index].description ?? "";
                                                              showBottomSheet(true, listTasks[index]);
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          GestureDetector(
                                                            child: Container(
                                                              padding: const EdgeInsets.all(5),
                                                              height: 40,
                                                              width: 40,
                                                              decoration: BoxDecoration(
                                                                color: const Color.fromRGBO(89, 57, 241, 1),
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              child: const Icon(
                                                                Icons.delete,
                                                                color: Colors.white,
                                                                size: 20,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              await taskCubit.removeTask(listTasks[index]);
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                key: ValueKey(index),
                                                child: Container(
                                                  margin: const EdgeInsets.only(top: 10),
                                                  padding: const EdgeInsets.only(
                                                    left: 20,
                                                    bottom: 20,
                                                    top: 20,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(255, 255, 255, 1),
                                                    border: Border.all(
                                                        color: const Color.fromARGB(11, 185, 145, 145), width: 0.5),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        offset: Offset(0, 4),
                                                        blurRadius: 10,
                                                        color: Color.fromRGBO(0, 0, 0, 0.13),
                                                      )
                                                    ],
                                                    borderRadius: const BorderRadius.all(Radius.zero),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            height: 60,
                                                            width: 60,
                                                            decoration: const BoxDecoration(),
                                                            child: Image.asset("assets/circle_image.png"),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          SizedBox(
                                                            width: 230,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  listTasks[index].title ?? "",
                                                                  style: GoogleFonts.inter(
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  listTasks[index].description ?? "",
                                                                  style: GoogleFonts.inter(
                                                                      color: const Color.fromRGBO(0, 0, 0, 0.7),
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  listTasks[index].date!,
                                                                  style: GoogleFonts.inter(
                                                                      color: const Color.fromRGBO(0, 0, 0, 0.7),
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Checkbox(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            activeColor: Colors.green,
                                                            value: listTasks[index].completed,
                                                            onChanged: (val) {
                                                              taskCubit.toggleTaskCompletion(listTasks[index]);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: listTasks.length,
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
          Positioned(
            top: 100.0, // Distance from the top
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                showBottomSheet(false);
              },
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              child: const Icon(
                size: 50,
                Icons.add,
                color: Color.fromRGBO(89, 57, 241, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
