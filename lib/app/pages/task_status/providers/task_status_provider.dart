import 'package:flutter/material.dart';

class TaskStatusProvider with ChangeNotifier {
  int _currentStep = 0;
  int get currentStep => _currentStep;
  int get stepLength => _taskStatus!.taskStatusList.length + 2;

  TaskStatusModel? _taskStatus;
  TaskStatusModel? get taskStatus => _taskStatus;

  bool inProgress = false;

  updateStatus() async {
    inProgress = true;
    notifyListeners();

    // TODO: fetch from DB
    await Future.delayed(Duration(seconds: 1));
    _taskStatus = __testData;
    refreshCurrentStep();
    print("$_currentStep $stepLength");
    inProgress = false;
    notifyListeners();
  }

  approve() async {
    if (null == _taskStatus) {
      return;
    }
    inProgress = true;
    notifyListeners();

    print("$_currentStep $stepLength");
    await Future.delayed(Duration(seconds: 1));

    if (_currentStep < 1) {
      // not started
      _taskStatus!.isStarted = true;
      //TODO: write DB
    } else if (_currentStep < (stepLength - 1)) {
      // started but not complete
      _taskStatus!.taskStatusList[_currentStep - 1].completedDate =
          DateTime.now();
      //TODO: write DB
    } else if (_currentStep < (stepLength)) {
      // complete
      _taskStatus!.isComplete = true;
      _taskStatus!.completedDate = DateTime.now();
      //TODO: write DB
    } else {
      // already complete
      // nop
    }
    refreshCurrentStep();

    inProgress = false;
    notifyListeners();
  }

  bool get isEnableApprove {
    bool _ret = false;
    final _now = DateTime.now();

    if (null == _taskStatus) {
      return false;
    }

    if (_currentStep < 1) {
      // not started
      _ret = _taskStatus!.start.isBefore(_now);
    } else if (_currentStep < (stepLength - 1)) {
      // started but not complete
      _ret =
          _taskStatus!.taskStatusList[_currentStep - 1].deadline.isBefore(_now);
    } else if (_currentStep < (stepLength)) {
      // complete
      _ret = _taskStatus!.end.isBefore(_now);
    } else {
      // already complete
      // nop
    }

    return _ret;
  }

  refreshCurrentStep() {
    if (null == _taskStatus) {
      _currentStep = 0;
      return;
    }

    if (false == _taskStatus!.isStarted) {
      // not started
      _currentStep = 0;
      return;
    }

    for (var i = 0; i < _taskStatus!.taskStatusList.length; i++) {
      if (null == _taskStatus!.taskStatusList[i].completedDate) {
        _currentStep = i + 1;
        return;
      }
    }
    _currentStep = stepLength - 1;
    return;
  }
}

final _now = DateTime.now();

TaskStatusModel __testData = TaskStatusModel(
    id: "demo00000000",
    name: "Demo Task",
    start: _now.add(Duration(days: -11)),
    end: _now,
    completedDate: null,
    isComplete: false,
    isStarted: false,
    taskStatusList: [
      TaskStatusItemModel(
        name: "Check Point",
        deadline: _now.add(Duration(days: -6)),
        completedDate: null,
      ),
      TaskStatusItemModel(
        name: "Check Point",
        deadline: _now.add(Duration(days: -5)),
        completedDate: null,
      ),
      TaskStatusItemModel(
        name: "Check Point",
        deadline: _now.add(Duration(days: -1)),
        completedDate: null,
      ),
    ]);

class TaskStatusModel {
  final String id;
  final String name;
  final DateTime start;
  final DateTime end;
  DateTime? completedDate;
  bool isComplete;
  bool isStarted;
  List<TaskStatusItemModel> taskStatusList;

  TaskStatusModel({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    required this.completedDate,
    required this.isComplete,
    required this.isStarted,
    required this.taskStatusList,
  });
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
}
