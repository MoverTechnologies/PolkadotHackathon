/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the Task type in your schema. */
@immutable
class Task extends Model {
  static const classType = const _TaskModelType();
  final String id;
  final String? _title;
  final TemporalDateTime? _start;
  final TemporalDateTime? _end;
  final String? _taskItems;
  final List<TaskItem>? _TaskItems;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  String get title {
    try {
      return _title!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  TemporalDateTime? get start {
    return _start;
  }

  TemporalDateTime? get end {
    return _end;
  }

  String? get taskItems {
    return _taskItems;
  }

  List<TaskItem>? get TaskItems {
    return _TaskItems;
  }

  TemporalDateTime? get createdAt {
    return _createdAt;
  }

  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const Task._internal(
      {required this.id,
      required title,
      start,
      end,
      taskItems,
      TaskItems,
      createdAt,
      updatedAt})
      : _title = title,
        _start = start,
        _end = end,
        _taskItems = taskItems,
        _TaskItems = TaskItems,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Task(
      {String? id,
      required String title,
      TemporalDateTime? start,
      TemporalDateTime? end,
      String? taskItems,
      List<TaskItem>? TaskItems}) {
    return Task._internal(
        id: id == null ? UUID.getUUID() : id,
        title: title,
        start: start,
        end: end,
        taskItems: taskItems,
        TaskItems: TaskItems != null
            ? List<TaskItem>.unmodifiable(TaskItems)
            : TaskItems);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Task &&
        id == other.id &&
        _title == other._title &&
        _start == other._start &&
        _end == other._end &&
        _taskItems == other._taskItems &&
        DeepCollectionEquality().equals(_TaskItems, other._TaskItems);
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Task {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer
        .write("start=" + (_start != null ? _start!.format() : "null") + ", ");
    buffer.write("end=" + (_end != null ? _end!.format() : "null") + ", ");
    buffer.write("taskItems=" + "$_taskItems" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Task copyWith(
      {String? id,
      String? title,
      TemporalDateTime? start,
      TemporalDateTime? end,
      String? taskItems,
      List<TaskItem>? TaskItems}) {
    return Task._internal(
        id: id ?? this.id,
        title: title ?? this.title,
        start: start ?? this.start,
        end: end ?? this.end,
        taskItems: taskItems ?? this.taskItems,
        TaskItems: TaskItems ?? this.TaskItems);
  }

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _title = json['title'],
        _start = json['start'] != null
            ? TemporalDateTime.fromString(json['start'])
            : null,
        _end = json['end'] != null
            ? TemporalDateTime.fromString(json['end'])
            : null,
        _taskItems = json['taskItems'],
        _TaskItems = json['TaskItems'] is List
            ? (json['TaskItems'] as List)
                .where((e) => e?['serializedData'] != null)
                .map((e) => TaskItem.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'])))
                .toList()
            : null,
        _createdAt = json['createdAt'] != null
            ? TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': _title,
        'start': _start?.format(),
        'end': _end?.format(),
        'taskItems': _taskItems,
        'TaskItems': _TaskItems?.map((TaskItem? e) => e?.toJson()).toList(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  static final QueryField ID = QueryField(fieldName: "task.id");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField START = QueryField(fieldName: "start");
  static final QueryField END = QueryField(fieldName: "end");
  static final QueryField TASKITEMS = QueryField(
      fieldName: "TaskItems",
      fieldType: ModelFieldType(ModelFieldTypeEnum.model,
          ofModelName: (TaskItem).toString()));
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Task";
    modelSchemaDefinition.pluralName = "Tasks";

    modelSchemaDefinition.authRules = [
      AuthRule(authStrategy: AuthStrategy.PUBLIC, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Task.TITLE,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Task.START,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Task.END,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Task.TASKITEMS,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
        key: Task.TASKITEMS,
        isRequired: false,
        ofModelName: (TaskItem).toString(),
        associatedKey: TaskItem.TASKID));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'createdAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'updatedAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));
  });
}

class _TaskModelType extends ModelType<Task> {
  const _TaskModelType();

  @override
  Task fromJson(Map<String, dynamic> jsonData) {
    return Task.fromJson(jsonData);
  }
}
