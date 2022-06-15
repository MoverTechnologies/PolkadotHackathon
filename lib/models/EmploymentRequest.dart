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
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the EmploymentRequest type in your schema. */
@immutable
class EmploymentRequest extends Model {
  static const classType = const _EmploymentRequestModelType();
  final String id;
  final String? _employer;
  final String? _employee;
  final TemporalDateTime? _start;
  final TemporalDateTime? _end;
  final int? _dayPerMonth;
  final double? _hourPerDay;
  final String? _currency;
  final int? _price;
  final TemporalDateTime? _createdAt;
  final TaskStatus? _taskStatus;
  final TemporalDateTime? _updatedAt;
  final String? _employmentRequestTaskStatusId;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get employer {
    return _employer;
  }
  
  String? get employee {
    return _employee;
  }
  
  TemporalDateTime get start {
    try {
      return _start!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get end {
    try {
      return _end!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get dayPerMonth {
    try {
      return _dayPerMonth!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get hourPerDay {
    try {
      return _hourPerDay!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get currency {
    try {
      return _currency!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get price {
    try {
      return _price!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get createdAt {
    try {
      return _createdAt!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TaskStatus? get taskStatus {
    return _taskStatus;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  String? get employmentRequestTaskStatusId {
    return _employmentRequestTaskStatusId;
  }
  
  const EmploymentRequest._internal({required this.id, employer, employee, required start, required end, required dayPerMonth, required hourPerDay, required currency, required price, required createdAt, taskStatus, updatedAt, employmentRequestTaskStatusId}): _employer = employer, _employee = employee, _start = start, _end = end, _dayPerMonth = dayPerMonth, _hourPerDay = hourPerDay, _currency = currency, _price = price, _createdAt = createdAt, _taskStatus = taskStatus, _updatedAt = updatedAt, _employmentRequestTaskStatusId = employmentRequestTaskStatusId;
  
  factory EmploymentRequest({String? id, String? employer, String? employee, required TemporalDateTime start, required TemporalDateTime end, required int dayPerMonth, required double hourPerDay, required String currency, required int price, required TemporalDateTime createdAt, TaskStatus? taskStatus, String? employmentRequestTaskStatusId}) {
    return EmploymentRequest._internal(
      id: id == null ? UUID.getUUID() : id,
      employer: employer,
      employee: employee,
      start: start,
      end: end,
      dayPerMonth: dayPerMonth,
      hourPerDay: hourPerDay,
      currency: currency,
      price: price,
      createdAt: createdAt,
      taskStatus: taskStatus,
      employmentRequestTaskStatusId: employmentRequestTaskStatusId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmploymentRequest &&
      id == other.id &&
      _employer == other._employer &&
      _employee == other._employee &&
      _start == other._start &&
      _end == other._end &&
      _dayPerMonth == other._dayPerMonth &&
      _hourPerDay == other._hourPerDay &&
      _currency == other._currency &&
      _price == other._price &&
      _createdAt == other._createdAt &&
      _taskStatus == other._taskStatus &&
      _employmentRequestTaskStatusId == other._employmentRequestTaskStatusId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("EmploymentRequest {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("employer=" + "$_employer" + ", ");
    buffer.write("employee=" + "$_employee" + ", ");
    buffer.write("start=" + (_start != null ? _start!.format() : "null") + ", ");
    buffer.write("end=" + (_end != null ? _end!.format() : "null") + ", ");
    buffer.write("dayPerMonth=" + (_dayPerMonth != null ? _dayPerMonth!.toString() : "null") + ", ");
    buffer.write("hourPerDay=" + (_hourPerDay != null ? _hourPerDay!.toString() : "null") + ", ");
    buffer.write("currency=" + "$_currency" + ", ");
    buffer.write("price=" + (_price != null ? _price!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("employmentRequestTaskStatusId=" + "$_employmentRequestTaskStatusId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  EmploymentRequest copyWith({String? id, String? employer, String? employee, TemporalDateTime? start, TemporalDateTime? end, int? dayPerMonth, double? hourPerDay, String? currency, int? price, TemporalDateTime? createdAt, TaskStatus? taskStatus, String? employmentRequestTaskStatusId}) {
    return EmploymentRequest._internal(
      id: id ?? this.id,
      employer: employer ?? this.employer,
      employee: employee ?? this.employee,
      start: start ?? this.start,
      end: end ?? this.end,
      dayPerMonth: dayPerMonth ?? this.dayPerMonth,
      hourPerDay: hourPerDay ?? this.hourPerDay,
      currency: currency ?? this.currency,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      taskStatus: taskStatus ?? this.taskStatus,
      employmentRequestTaskStatusId: employmentRequestTaskStatusId ?? this.employmentRequestTaskStatusId);
  }
  
  EmploymentRequest.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _employer = json['employer'],
      _employee = json['employee'],
      _start = json['start'] != null ? TemporalDateTime.fromString(json['start']) : null,
      _end = json['end'] != null ? TemporalDateTime.fromString(json['end']) : null,
      _dayPerMonth = (json['dayPerMonth'] as num?)?.toInt(),
      _hourPerDay = (json['hourPerDay'] as num?)?.toDouble(),
      _currency = json['currency'],
      _price = (json['price'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _taskStatus = json['taskStatus']?['serializedData'] != null
        ? TaskStatus.fromJson(new Map<String, dynamic>.from(json['taskStatus']['serializedData']))
        : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null,
      _employmentRequestTaskStatusId = json['employmentRequestTaskStatusId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'employer': _employer, 'employee': _employee, 'start': _start?.format(), 'end': _end?.format(), 'dayPerMonth': _dayPerMonth, 'hourPerDay': _hourPerDay, 'currency': _currency, 'price': _price, 'createdAt': _createdAt?.format(), 'taskStatus': _taskStatus?.toJson(), 'updatedAt': _updatedAt?.format(), 'employmentRequestTaskStatusId': _employmentRequestTaskStatusId
  };

  static final QueryField ID = QueryField(fieldName: "employmentRequest.id");
  static final QueryField EMPLOYER = QueryField(fieldName: "employer");
  static final QueryField EMPLOYEE = QueryField(fieldName: "employee");
  static final QueryField START = QueryField(fieldName: "start");
  static final QueryField END = QueryField(fieldName: "end");
  static final QueryField DAYPERMONTH = QueryField(fieldName: "dayPerMonth");
  static final QueryField HOURPERDAY = QueryField(fieldName: "hourPerDay");
  static final QueryField CURRENCY = QueryField(fieldName: "currency");
  static final QueryField PRICE = QueryField(fieldName: "price");
  static final QueryField CREATEDAT = QueryField(fieldName: "createdAt");
  static final QueryField TASKSTATUS = QueryField(
    fieldName: "taskStatus",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (TaskStatus).toString()));
  static final QueryField EMPLOYMENTREQUESTTASKSTATUSID = QueryField(fieldName: "employmentRequestTaskStatusId");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "EmploymentRequest";
    modelSchemaDefinition.pluralName = "EmploymentRequests";
    
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
      key: EmploymentRequest.EMPLOYER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.EMPLOYEE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.START,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.END,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.DAYPERMONTH,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.HOURPERDAY,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.CURRENCY,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.PRICE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.CREATEDAT,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasOne(
      key: EmploymentRequest.TASKSTATUS,
      isRequired: false,
      ofModelName: (TaskStatus).toString(),
      associatedKey: TaskStatus.ID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.EMPLOYMENTREQUESTTASKSTATUSID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _EmploymentRequestModelType extends ModelType<EmploymentRequest> {
  const _EmploymentRequestModelType();
  
  @override
  EmploymentRequest fromJson(Map<String, dynamic> jsonData) {
    return EmploymentRequest.fromJson(jsonData);
  }
}