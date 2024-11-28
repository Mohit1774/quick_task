import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task {
  String id;
  String title;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.isCompleted
  });

  // Factory constructor to create Task from a ParseObject
  factory Task.fromParse(ParseObject parseObject) {
    return Task(
      id: parseObject.objectId ?? '',
      title: parseObject.get<String>('title') ?? '',
      dueDate: parseObject.get<DateTime>('dueDate') ?? DateTime.now(),
      isCompleted: parseObject.get<bool>('isCompleted') ?? false,
    );
  }
}
