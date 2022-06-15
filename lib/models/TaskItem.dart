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

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the TaskItem type in your schema. */
@immutable
class TaskItem extends Model {
  static const classType = const _TaskItemModelType();
  final String id;
  final String? _title;
  final TemporalDateTime? _deadlin;
  final TemporalDateTime? _completedDate;
  final String? _taskID;
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
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get deadlin {
    try {
      return _deadlin!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime? get completedDate {
    return _completedDate;
  }
  
  String get taskID {
    try {
      return _taskID!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const TaskItem._internal({required this.id, required title, required deadlin, completedDate, required taskID, createdAt, updatedAt}): _title = title, _deadlin = deadlin, _completedDate = completedDate, _taskID = taskID, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory TaskItem({String? id, required String title, required TemporalDateTime deadlin, TemporalDateTime? completedDate, required String taskID}) {
    return TaskItem._internal(
      id: id == null ? UUID.getUUID() : id,
      title: title,
      deadlin: deadlin,
      completedDate: completedDate,
      taskID: taskID);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaskItem &&
      id == other.id &&
      _title == other._title &&
      _deadlin == other._deadlin &&
      _completedDate == other._completedDate &&
      _taskID == other._taskID;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("TaskItem {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("deadlin=" + (_deadlin != null ? _deadlin!.format() : "null") + ", ");
    buffer.write("completedDate=" + (_completedDate != null ? _completedDate!.format() : "null") + ", ");
    buffer.write("taskID=" + "$_taskID" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  TaskItem copyWith({String? id, String? title, TemporalDateTime? deadlin, TemporalDateTime? completedDate, String? taskID}) {
    return TaskItem._internal(
      id: id ?? this.id,
      title: title ?? this.title,
      deadlin: deadlin ?? this.deadlin,
      completedDate: completedDate ?? this.completedDate,
      taskID: taskID ?? this.taskID);
  }
  
  TaskItem.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _deadlin = json['deadlin'] != null ? TemporalDateTime.fromString(json['deadlin']) : null,
      _completedDate = json['completedDate'] != null ? TemporalDateTime.fromString(json['completedDate']) : null,
      _taskID = json['taskID'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'deadlin': _deadlin?.format(), 'completedDate': _completedDate?.format(), 'taskID': _taskID, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "taskItem.id");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField DEADLIN = QueryField(fieldName: "deadlin");
  static final QueryField COMPLETEDDATE = QueryField(fieldName: "completedDate");
  static final QueryField TASKID = QueryField(fieldName: "taskID");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TaskItem";
    modelSchemaDefinition.pluralName = "TaskItems";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TaskItem.TITLE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TaskItem.DEADLIN,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TaskItem.COMPLETEDDATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TaskItem.TASKID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _TaskItemModelType extends ModelType<TaskItem> {
  const _TaskItemModelType();
  
  @override
  TaskItem fromJson(Map<String, dynamic> jsonData) {
    return TaskItem.fromJson(jsonData);
  }
}