import 'package:mover/models/EmploymentRequest.dart';

class TaskStatusModel {
  final String name;
  DateTime? completedDate;
  bool isComplete;
  bool isStarted;
  List<TaskStatusItemModel> taskStatusList;

  TaskStatusModel({
    required this.name,
    required this.completedDate,
    required this.isComplete,
    required this.isStarted,
    required this.taskStatusList,
  });

  factory TaskStatusModel.fromJson(Map<String, dynamic> json) {
    return TaskStatusModel(
      name: json['name'] as String,
      completedDate: json['completedDate'] == null
          ? null
          : DateTime.parse(json['completedDate'] as String),
      isComplete: json['isComplete'] as bool,
      isStarted: json['isStarted'] as bool,
      taskStatusList: (json['taskStatusList'] as List<dynamic>)
          .map((e) => TaskStatusItemModel.fromJson(e))
          .toList(),
    );
  }

  factory TaskStatusModel.fromEmploymentRequest(EmploymentRequest _request) {
    List<TaskStatusItemModel> _taskStatusList = [];
    final _start = _request.start!.getDateTimeInUtc();

    for (var i = 0; i < (_request.periodMonth - 1); i++) {
      _taskStatusList.add(TaskStatusItemModel(
        name: 'check point ${i + 1}',
        completedDate: null,
        deadline: DateTime(_start.year, _start.month + i + 1, _start.day),
      ));
    }

    return TaskStatusModel(
      name: "Task Status",
      completedDate: null,
      isComplete: false,
      isStarted: false,
      taskStatusList: _taskStatusList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'completedDate': completedDate?.toIso8601String(),
      'isComplete': isComplete,
      'isStarted': isStarted,
      'taskStatusList': taskStatusList.map((e) => e.toJson()).toList(),
    };
  }
}

class TaskStatusItemModel {
  final String name;
  final DateTime deadline;
  DateTime? completedDate;

  TaskStatusItemModel({
    required this.name,
    required this.deadline,
    required this.completedDate,
  });

  @override
  String toString() {
    return 'TaskStatusItemModel{name: $name, deadline: $deadline, completedDate: $completedDate}';
  }

  factory TaskStatusItemModel.fromJson(Map<String, dynamic> e) {
    return TaskStatusItemModel(
      name: e['name'] as String,
      deadline: DateTime.parse(e['deadline'] as String),
      completedDate: e['completedDate'] == null
          ? null
          : DateTime.parse(e['completedDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'deadline': deadline.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
    };
  }
}
