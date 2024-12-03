class DeleteModel {
  late int? taskNo;
  late bool isSynced; // New field for synchronization status // New field for the last update timestamp

  DeleteModel({
  this.taskNo,
    this.isSynced = false, // Defaulted to false
  });
}
