import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/models/todo_request_modal.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._createInstance();
  static dynamic _database;
  String taskTable = "task_table";
  String deleteTable = "delete_table";
  String taskNo = "id";
  String title = "title";
  String description = "description";
  String status = "status";
  String date = "createdAt";
  String updatedDate = "updatedAt";
  String isSynced = "isSynced";
  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    return _databaseHelper;
  }

  Future<Database> initializeDB() async {
    Database database =
        await openDatabase(join(await getDatabasesPath(), "PlayerDB.db"), version: 1, onCreate: _createdb);
    return database;
  }

  Future<Database> get database async {
    _database = await initializeDB();
    return _database;
  }

  void _createdb(Database db, int version) async {
    await db.execute('''CREATE TABLE $taskTable(
         $taskNo INTEGER PRIMARY KEY AUTOINCREMENT,
         $title TEXT,
         $description TEXT,
         $status INTEGER DEFAULT 0,
         $date DATETIME DEFAULT CURRENT_TIMESTAMP,
         $updatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
         $isSynced INTEGER DEFAULT 0
       )''');

    await db.execute('''CREATE TABLE $deleteTable(
         $taskNo INTEGER DEFAULT 0,
         $isSynced INTEGER DEFAULT 0
       )''');
  }

  Future<List<Map<String, dynamic>>> getTasksMapList() async {
    Database db = await database;
    var result = await db.query(taskTable);
    return result;
  }

  Future<List<Map<String, dynamic>>> getUnsyncTasksMapList() async {
    Database db = await database;
    var result = await db.query(
      taskTable, where: 'isSynced = ?', // The condition
      whereArgs: [0],
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getUnsyncTasksDeleteList() async {
    Database db = await database;
    var result = await db.query(
      deleteTable, where: 'isSynced = ?', // The condition
      whereArgs: [0],
    );
    return result;
  }

  Future<List<ToDoModelClass>> getTaskList() async {
    var taskMap = await getTasksMapList();
    List<ToDoModelClass> taskList = [];
    for (int i = 0; i < taskMap.length; i++) {
      taskList.add(ToDoModelClass.fromMapObject(taskMap[i]));
    }
    return taskList;
  }

  Future<List<ToDoModelClass>> getTasksDelete() async {
    var taskMap = await getTasksMapList();
    List<ToDoModelClass> taskList = [];
    for (int i = 0; i < taskMap.length; i++) {
      taskList.add(ToDoModelClass.fromMapObject(taskMap[i]));
    }
    return taskList;
  }

  Future<List<ToDoModelClass>> getUnsyncTaskList() async {
    var taskMap = await getUnsyncTasksMapList();
    List<ToDoModelClass> taskList = [];
    for (int i = 0; i < taskMap.length; i++) {
      taskList.add(ToDoModelClass.fromMapObject(taskMap[i]));
    }
    return taskList;
  }

  Future<List<ToDoModelClass>> getUnsyncTaskDeleteList() async {
    var taskMap = await getUnsyncTasksDeleteList();
    List<ToDoModelClass> taskList = [];
    for (int i = 0; i < taskMap.length; i++) {
      taskList.add(ToDoModelClass.fromMapObject(taskMap[i]));
    }
    return taskList;
  }

  Future<int> insertTask(ToDoModelClass toDoModelClassObject) async {
    Database db = await database;
    var result = await db.insert(taskTable, toDoModelClassObject.toDoModelClassMap());
    return result;
  }

  Future<int> updateTask(ToDoModelClass toDoModelClassObject) async {
    Database db = await database;
    var result = await db.update(taskTable, toDoModelClassObject.toDoModelClassMap(),
        where: '$taskNo = ?', whereArgs: [toDoModelClassObject.taskNo]);
    return result;
  }

  Future<int> deleteTableUpdate(ToDoModelClass toDoModelClassObject) async {
    Database db = await database;
    var result = await db.update(deleteTable, {isSynced: 'true'},
        where: '$taskNo = ?', whereArgs: [toDoModelClassObject.taskNo]);
    return result;
  }

  Future<int> deleteTask(ToDoModelClass toDoModelClassObject) async {
    Database db = await database;
    int result =
        //  await db.rawDelete('DELETE FROM $taskTable WHERE $taskNo = $id');
        await db.delete(
      taskTable,
      where: "id = ?",
      whereArgs: [toDoModelClassObject.taskNo],
    );
    var deleteUpdated = await db.insert(deleteTable, {
      'id': toDoModelClassObject.taskNo,
      'isSynced': 0, // Store boolean as integer (0 or 1)
    });
    return result;
  }
}
