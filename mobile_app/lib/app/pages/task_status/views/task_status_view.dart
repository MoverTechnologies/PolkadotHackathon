import 'package:flutter/material.dart';
import 'package:mover/app/pages/mod_order/models/mod_model.dart';
import 'package:mover/app/pages/mod_pay/views/mod_pay_view.dart';
import 'package:mover/models/EmploymentRequest.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/task_status_model.dart';
import '../providers/task_status_provider.dart';
import "package:intl/intl.dart";

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskStatusView extends StatefulWidget {
  TaskStatusView({Key? key, required this.mod, required this.request}) : super(key: key);

  final ModModel mod;
  final EmploymentRequest request;
  @override
  State<TaskStatusView> createState() => _TaskStatusViewState();
}

class _TaskStatusViewState extends State<TaskStatusView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskStatusProvider>().setTaskStatus(widget.request);
    });
  }

  @override
  Widget build(BuildContext context) {
    int _currentStep = context.watch<TaskStatusProvider>().currentStep;
    TaskStatusModel? _taskStatus = context.watch<TaskStatusProvider>().taskStatus;
    List<Step> _steps = (null == _taskStatus) ? [] : _getSteps(_taskStatus);

    return (null == _taskStatus)
        ? const SizedBox(width: 50, height: 50, child: CircularProgressIndicator())
        : Column(
            children: [
              Text("${_taskStatus.name}", style: TextStyle(fontSize: 20)),
              Theme(
                  data: ThemeData(
                    colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.black),
                  ),
                  child: Stepper(
                    currentStep: _currentStep,
                    controlsBuilder: (BuildContext context, ControlsDetails? details) {
                      if (_taskStatus.isComplete) {
                        return const SizedBox();
                      }
                      return Row(
                        children: <Widget>[
                          ElevatedButton(
                            // onPressed: (context.read<TaskStatusProvider>().isEnableApprove) ? details!.onStepContinue : null,
                            onPressed: details!.onStepContinue,
                            child: (context.read<TaskStatusProvider>().inProgress)
                                ? SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                      color: Colors.white,
                                    ))
                                : Text(
                                    AppLocalizations.of(context)!.approve,
                                  ),
                          ),
                        ],
                      );
                    },
                    onStepCancel: null,
                    onStepContinue: () {
                      context.read<TaskStatusProvider>().approve();
                    },
                    steps: _steps,
                  )),
              if (_taskStatus.isComplete)
                TextButton(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color.fromARGB(255, 206, 219, 26), Color.fromARGB(255, 113, 211, 34)],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.centerRight,
                        ),
                      ),
                      child: Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 102, 102, 102),
                          highlightColor: Color.fromARGB(255, 187, 187, 187),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.complete,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Icon(Icons.arrow_forward)
                            ],
                          )),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ModPayCheckView(
                                    mod: widget.mod,
                                    request: widget.request,
                                  )),
                          (route) => false);
                    }),
            ],
          );
  }

  List<Step> _getSteps(TaskStatusModel _taskStatusModel) {
    List<Step> steps = [];
    bool _isActive = false;
    bool _foundActiveTask = false;

    // start
    steps.add(Step(
      title: Column(
        children: [Text("${AppLocalizations.of(context)!.start} ${_formatter.format(widget.request.start!.getDateTimeInUtc())}")],
      ),
      content: Align(alignment: Alignment.topLeft, child: Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(AppLocalizations.of(context)!.startModWork))),
      state: (_taskStatusModel.isStarted) ? StepState.complete : StepState.disabled,
      isActive: !_taskStatusModel.isStarted,
    ));
    if (!_taskStatusModel.isStarted) {
      _foundActiveTask = true;
    }

    // check point
    for (TaskStatusItemModel item in _taskStatusModel.taskStatusList) {
      steps.add(Step(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${item.name} ${_formatter.format(item.deadline)}"),
            if (null != item.completedDate) Text("${AppLocalizations.of(context)!.done} ${_formatter.format(item.completedDate!)}"),
          ],
        ),
        content: Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: (context.read<TaskStatusProvider>().isEnableApprove)
                    ? Text(
                        AppLocalizations.of(context)!.approveModWork,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.green),
                      )
                    : Text(
                        AppLocalizations.of(context)!.waitForCheckPoint,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),
                      ))),
        state: (null != item.completedDate) ? StepState.complete : StepState.disabled,
        isActive: (_foundActiveTask) ? false : (null == item.completedDate),
      ));
      if (null == item.completedDate) {
        _foundActiveTask = true;
      }
    }

    // end
    steps.add(Step(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${AppLocalizations.of(context)!.end} ${_formatter.format(widget.request.end!.getDateTimeInUtc())}"),
          if (_taskStatusModel.isComplete) Text("${AppLocalizations.of(context)!.done} ${_formatter.format(_taskStatusModel.completedDate!)}"),
        ],
      ),
      content: Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: (!_taskStatusModel.isComplete) ? Text(AppLocalizations.of(context)!.letsFinalApprove) : Text("✅${AppLocalizations.of(context)!.allDone}"))),
      state: (_taskStatusModel.isComplete) ? StepState.complete : StepState.disabled,
      isActive: (_foundActiveTask) ? false : !_taskStatusModel.isComplete,
    ));

    return steps;
  }

  final _formatter = DateFormat('yyyy/MM/dd');
}
