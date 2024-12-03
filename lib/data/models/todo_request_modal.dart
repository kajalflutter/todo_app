class ToDoModelClass {
  late int? taskNo;
  late String? title;
  late String? description;
  late String? date;
  late bool completed;
  late bool isSynced; // New field for synchronization status
  late String? updatedDate; // New field for the last update timestamp

  ToDoModelClass({
    this.taskNo,
     this.title,
     this.description,
    this.date,
    this.completed = false, // Defaulted to false
    this.isSynced = false, // Defaulted to false
    this.updatedDate, // Required field for updated date
  });

  // Convert the object into a Map for database storage
  Map<String, dynamic> toDoModelClassMap() {
    return {
      'id': taskNo,
      'title': title,
      'description': description,
      'createdAt': date,
      'status': completed ? 1 : 0, // Store boolean as integer (0 or 1)
      'isSynced': isSynced ? 1 : 0, // Store boolean as integer (0 or 1)
      'updatedAt': updatedDate, // Store as string
    };
  }

  ToDoModelClass copyWith({
    int? taskNo,
    String? title,
    String? description,
    String? date,
    String? updatedDate,
    bool? completed,
    bool? isSynced,
  }) {
    return ToDoModelClass(
      taskNo: taskNo ?? this.taskNo,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      updatedDate: updatedDate ?? this.updatedDate,
      completed: completed ?? this.completed,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  // Construct the object from a Map (deserialization)
  ToDoModelClass.fromMapObject(Map<String, dynamic> map) {
    taskNo = map['id'] is String ? int.tryParse(map['id']) : map['id'];
    title = map['title'];
    description = map['description'];
    date = map['createdAt'];
    completed = map['status'] == 1; // Convert integer to boolean
    isSynced = map['isSynced'] == 1; // Convert integer to boolean
    updatedDate = map['updatedAt']; // Deserialize string to string
  }

  @override
  String toString() {
    return '{taskNo:$taskNo, title:$title, description:$description, date:$date, completed:$completed, isSynced:$isSynced, updatedDate:$updatedDate}';
  }
}
