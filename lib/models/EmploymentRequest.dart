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


/** This is an auto generated class representing the EmploymentRequest type in your schema. */
@immutable
class EmploymentRequest extends Model {
  static const classType = const _EmploymentRequestModelType();
  final String id;
  final String? _employerWallet;
  final String? _employeeWallet;
  final TemporalDateTime? _start;
  final TemporalDateTime? _end;
  final int? _dayPerMonth;
  final double? _hourPerDay;
  final int? _periodMonth;
  final String? _currency;
  final int? _price;
  final String? _progressStatus;
  final String? _extended;
  final int? _lockMonth;
  final int? _vestingMonth;
  final String? _agreementId;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get employerWallet {
    return _employerWallet;
  }
  
  String? get employeeWallet {
    return _employeeWallet;
  }
  
  TemporalDateTime? get start {
    return _start;
  }
  
  TemporalDateTime? get end {
    return _end;
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
  
  int get periodMonth {
    try {
      return _periodMonth!;
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
  
  String? get progressStatus {
    return _progressStatus;
  }
  
  String? get extended {
    return _extended;
  }
  
  int? get lockMonth {
    return _lockMonth;
  }
  
  int? get vestingMonth {
    return _vestingMonth;
  }
  
  String? get agreementId {
    return _agreementId;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const EmploymentRequest._internal({required this.id, employerWallet, employeeWallet, start, end, required dayPerMonth, required hourPerDay, required periodMonth, required currency, required price, progressStatus, extended, lockMonth, vestingMonth, agreementId, createdAt, updatedAt}): _employerWallet = employerWallet, _employeeWallet = employeeWallet, _start = start, _end = end, _dayPerMonth = dayPerMonth, _hourPerDay = hourPerDay, _periodMonth = periodMonth, _currency = currency, _price = price, _progressStatus = progressStatus, _extended = extended, _lockMonth = lockMonth, _vestingMonth = vestingMonth, _agreementId = agreementId, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory EmploymentRequest({String? id, String? employerWallet, String? employeeWallet, TemporalDateTime? start, TemporalDateTime? end, required int dayPerMonth, required double hourPerDay, required int periodMonth, required String currency, required int price, String? progressStatus, String? extended, int? lockMonth, int? vestingMonth, String? agreementId}) {
    return EmploymentRequest._internal(
      id: id == null ? UUID.getUUID() : id,
      employerWallet: employerWallet,
      employeeWallet: employeeWallet,
      start: start,
      end: end,
      dayPerMonth: dayPerMonth,
      hourPerDay: hourPerDay,
      periodMonth: periodMonth,
      currency: currency,
      price: price,
      progressStatus: progressStatus,
      extended: extended,
      lockMonth: lockMonth,
      vestingMonth: vestingMonth,
      agreementId: agreementId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmploymentRequest &&
      id == other.id &&
      _employerWallet == other._employerWallet &&
      _employeeWallet == other._employeeWallet &&
      _start == other._start &&
      _end == other._end &&
      _dayPerMonth == other._dayPerMonth &&
      _hourPerDay == other._hourPerDay &&
      _periodMonth == other._periodMonth &&
      _currency == other._currency &&
      _price == other._price &&
      _progressStatus == other._progressStatus &&
      _extended == other._extended &&
      _lockMonth == other._lockMonth &&
      _vestingMonth == other._vestingMonth &&
      _agreementId == other._agreementId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("EmploymentRequest {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("employerWallet=" + "$_employerWallet" + ", ");
    buffer.write("employeeWallet=" + "$_employeeWallet" + ", ");
    buffer.write("start=" + (_start != null ? _start!.format() : "null") + ", ");
    buffer.write("end=" + (_end != null ? _end!.format() : "null") + ", ");
    buffer.write("dayPerMonth=" + (_dayPerMonth != null ? _dayPerMonth!.toString() : "null") + ", ");
    buffer.write("hourPerDay=" + (_hourPerDay != null ? _hourPerDay!.toString() : "null") + ", ");
    buffer.write("periodMonth=" + (_periodMonth != null ? _periodMonth!.toString() : "null") + ", ");
    buffer.write("currency=" + "$_currency" + ", ");
    buffer.write("price=" + (_price != null ? _price!.toString() : "null") + ", ");
    buffer.write("progressStatus=" + "$_progressStatus" + ", ");
    buffer.write("extended=" + "$_extended" + ", ");
    buffer.write("lockMonth=" + (_lockMonth != null ? _lockMonth!.toString() : "null") + ", ");
    buffer.write("vestingMonth=" + (_vestingMonth != null ? _vestingMonth!.toString() : "null") + ", ");
    buffer.write("agreementId=" + "$_agreementId" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  EmploymentRequest copyWith({String? id, String? employerWallet, String? employeeWallet, TemporalDateTime? start, TemporalDateTime? end, int? dayPerMonth, double? hourPerDay, int? periodMonth, String? currency, int? price, String? progressStatus, String? extended, int? lockMonth, int? vestingMonth, String? agreementId}) {
    return EmploymentRequest._internal(
      id: id ?? this.id,
      employerWallet: employerWallet ?? this.employerWallet,
      employeeWallet: employeeWallet ?? this.employeeWallet,
      start: start ?? this.start,
      end: end ?? this.end,
      dayPerMonth: dayPerMonth ?? this.dayPerMonth,
      hourPerDay: hourPerDay ?? this.hourPerDay,
      periodMonth: periodMonth ?? this.periodMonth,
      currency: currency ?? this.currency,
      price: price ?? this.price,
      progressStatus: progressStatus ?? this.progressStatus,
      extended: extended ?? this.extended,
      lockMonth: lockMonth ?? this.lockMonth,
      vestingMonth: vestingMonth ?? this.vestingMonth,
      agreementId: agreementId ?? this.agreementId);
  }
  
  EmploymentRequest.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _employerWallet = json['employerWallet'],
      _employeeWallet = json['employeeWallet'],
      _start = json['start'] != null ? TemporalDateTime.fromString(json['start']) : null,
      _end = json['end'] != null ? TemporalDateTime.fromString(json['end']) : null,
      _dayPerMonth = (json['dayPerMonth'] as num?)?.toInt(),
      _hourPerDay = (json['hourPerDay'] as num?)?.toDouble(),
      _periodMonth = (json['periodMonth'] as num?)?.toInt(),
      _currency = json['currency'],
      _price = (json['price'] as num?)?.toInt(),
      _progressStatus = json['progressStatus'],
      _extended = json['extended'],
      _lockMonth = (json['lockMonth'] as num?)?.toInt(),
      _vestingMonth = (json['vestingMonth'] as num?)?.toInt(),
      _agreementId = json['agreementId'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'employerWallet': _employerWallet, 'employeeWallet': _employeeWallet, 'start': _start?.format(), 'end': _end?.format(), 'dayPerMonth': _dayPerMonth, 'hourPerDay': _hourPerDay, 'periodMonth': _periodMonth, 'currency': _currency, 'price': _price, 'progressStatus': _progressStatus, 'extended': _extended, 'lockMonth': _lockMonth, 'vestingMonth': _vestingMonth, 'agreementId': _agreementId, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "employmentRequest.id");
  static final QueryField EMPLOYERWALLET = QueryField(fieldName: "employerWallet");
  static final QueryField EMPLOYEEWALLET = QueryField(fieldName: "employeeWallet");
  static final QueryField START = QueryField(fieldName: "start");
  static final QueryField END = QueryField(fieldName: "end");
  static final QueryField DAYPERMONTH = QueryField(fieldName: "dayPerMonth");
  static final QueryField HOURPERDAY = QueryField(fieldName: "hourPerDay");
  static final QueryField PERIODMONTH = QueryField(fieldName: "periodMonth");
  static final QueryField CURRENCY = QueryField(fieldName: "currency");
  static final QueryField PRICE = QueryField(fieldName: "price");
  static final QueryField PROGRESSSTATUS = QueryField(fieldName: "progressStatus");
  static final QueryField EXTENDED = QueryField(fieldName: "extended");
  static final QueryField LOCKMONTH = QueryField(fieldName: "lockMonth");
  static final QueryField VESTINGMONTH = QueryField(fieldName: "vestingMonth");
  static final QueryField AGREEMENTID = QueryField(fieldName: "agreementId");
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
      key: EmploymentRequest.EMPLOYERWALLET,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.EMPLOYEEWALLET,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.START,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.END,
      isRequired: false,
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
      key: EmploymentRequest.PERIODMONTH,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
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
      key: EmploymentRequest.PROGRESSSTATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.EXTENDED,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.LOCKMONTH,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.VESTINGMONTH,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: EmploymentRequest.AGREEMENTID,
      isRequired: false,
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

class _EmploymentRequestModelType extends ModelType<EmploymentRequest> {
  const _EmploymentRequestModelType();
  
  @override
  EmploymentRequest fromJson(Map<String, dynamic> jsonData) {
    return EmploymentRequest.fromJson(jsonData);
  }
}