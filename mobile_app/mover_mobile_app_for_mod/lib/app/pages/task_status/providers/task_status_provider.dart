import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/models/ModelProvider.dart';

import '../models/task_status_model.dart';

class TaskStatusProvider with ChangeNotifier {
  int _currentStep = 0;
  int get currentStep => _currentStep;
  int get stepLength => _taskStatus!.taskStatusList.length + 2;

  TaskStatusModel? _taskStatus;
  TaskStatusModel? get taskStatus => _taskStatus;
  EmploymentRequest? _employmentRequest;

  bool inProgress = false;

  setTaskStatus(EmploymentRequest _request) {
    _currentStep = 0;
    if (null == _request.progressStatus) {
      return;
    }
    try {
      _taskStatus = TaskStatusModel.fromJson(jsonDecode(_request.progressStatus!));
      _employmentRequest = _request;
      for (var i = 0; i < _taskStatus!.taskStatusList.length; i++) {
        if (null == _taskStatus!.taskStatusList[i].completedDate) {
          // find the first uncompleted step
          _currentStep = i;
          break;
        }
      }
      notifyListeners();
    } catch (e) {
      print("##### Error in setTaskStatus ##### $e");
    }
    print(_currentStep);
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
      AmplifyEndpoint().updateTaskStatus(_employmentRequest!.id, jsonEncode(_taskStatus!.toJson()));
    } else if (_currentStep < (stepLength - 1)) {
      // started but not complete
      _taskStatus!.taskStatusList[_currentStep - 1].completedDate = DateTime.now();
      AmplifyEndpoint().updateTaskStatus(_employmentRequest!.id, jsonEncode(_taskStatus!.toJson()));
    } else if (_currentStep < (stepLength)) {
      // complete
      _taskStatus!.isComplete = true;
      _taskStatus!.completedDate = DateTime.now();
      AmplifyEndpoint().updateTaskStatus(_employmentRequest!.id, jsonEncode(_taskStatus!.toJson()));
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
      _ret = _employmentRequest!.start!.getDateTimeInUtc().isBefore(_now);
    } else if (_currentStep < (stepLength - 1)) {
      // started but not complete
      _ret = _taskStatus!.taskStatusList[_currentStep - 1].deadline.isBefore(_now);
    } else if (_currentStep < (stepLength)) {
      // complete
      _ret = _employmentRequest!.end!.getDateTimeInUtc().isBefore(_now);
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
