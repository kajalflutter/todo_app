// To parse this JSON data, do
//
//     final taskResponse = taskResponseFromJson(jsonString);

import 'dart:convert';

TaskResponse taskResponseFromJson(String str) => TaskResponse.fromJson(json.decode(str));

String taskResponseToJson(TaskResponse data) => json.encode(data.toJson());

class TaskResponse {
  String message;

  TaskResponse({
    required this.message,
  });

  TaskResponse copyWith({
    String? message,
  }) =>
      TaskResponse(
        message: message ?? this.message,
      );

  factory TaskResponse.fromJson(Map<String, dynamic> json) => TaskResponse(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
