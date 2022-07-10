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
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the MoverUser type in your schema. */
@immutable
class MoverUser extends Model {
  static const classType = const _MoverUserModelType();
  final String id;
  final String? _nickname;
  final String? _iconUrl;
  final List<String>? _languagesAsISO639;
  final String? _email;
  final String? _discordID;
  final String? _wallet;
  final String? _firebaseTokenID;
  final String? _extended;
  final String? _company;
  final double? _rating;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get nickname {
    try {
      return _nickname!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get iconUrl {
    try {
      return _iconUrl!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String>? get languagesAsISO639 {
    return _languagesAsISO639;
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get discordID {
    return _discordID;
  }
  
  String get wallet {
    try {
      return _wallet!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get firebaseTokenID {
    try {
      return _firebaseTokenID!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get extended {
    return _extended;
  }
  
  String? get company {
    return _company;
  }
  
  double? get rating {
    return _rating;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const MoverUser._internal({required this.id, required nickname, required iconUrl, languagesAsISO639, required email, discordID, required wallet, required firebaseTokenID, extended, company, rating, createdAt, updatedAt}): _nickname = nickname, _iconUrl = iconUrl, _languagesAsISO639 = languagesAsISO639, _email = email, _discordID = discordID, _wallet = wallet, _firebaseTokenID = firebaseTokenID, _extended = extended, _company = company, _rating = rating, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory MoverUser({String? id, required String nickname, required String iconUrl, List<String>? languagesAsISO639, required String email, String? discordID, required String wallet, required String firebaseTokenID, String? extended, String? company, double? rating}) {
    return MoverUser._internal(
      id: id == null ? UUID.getUUID() : id,
      nickname: nickname,
      iconUrl: iconUrl,
      languagesAsISO639: languagesAsISO639 != null ? List<String>.unmodifiable(languagesAsISO639) : languagesAsISO639,
      email: email,
      discordID: discordID,
      wallet: wallet,
      firebaseTokenID: firebaseTokenID,
      extended: extended,
      company: company,
      rating: rating);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MoverUser &&
      id == other.id &&
      _nickname == other._nickname &&
      _iconUrl == other._iconUrl &&
      DeepCollectionEquality().equals(_languagesAsISO639, other._languagesAsISO639) &&
      _email == other._email &&
      _discordID == other._discordID &&
      _wallet == other._wallet &&
      _firebaseTokenID == other._firebaseTokenID &&
      _extended == other._extended &&
      _company == other._company &&
      _rating == other._rating;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("MoverUser {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("nickname=" + "$_nickname" + ", ");
    buffer.write("iconUrl=" + "$_iconUrl" + ", ");
    buffer.write("languagesAsISO639=" + (_languagesAsISO639 != null ? _languagesAsISO639!.toString() : "null") + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("discordID=" + "$_discordID" + ", ");
    buffer.write("wallet=" + "$_wallet" + ", ");
    buffer.write("firebaseTokenID=" + "$_firebaseTokenID" + ", ");
    buffer.write("extended=" + "$_extended" + ", ");
    buffer.write("company=" + "$_company" + ", ");
    buffer.write("rating=" + (_rating != null ? _rating!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  MoverUser copyWith({String? id, String? nickname, String? iconUrl, List<String>? languagesAsISO639, String? email, String? discordID, String? wallet, String? firebaseTokenID, String? extended, String? company, double? rating}) {
    return MoverUser._internal(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      iconUrl: iconUrl ?? this.iconUrl,
      languagesAsISO639: languagesAsISO639 ?? this.languagesAsISO639,
      email: email ?? this.email,
      discordID: discordID ?? this.discordID,
      wallet: wallet ?? this.wallet,
      firebaseTokenID: firebaseTokenID ?? this.firebaseTokenID,
      extended: extended ?? this.extended,
      company: company ?? this.company,
      rating: rating ?? this.rating);
  }
  
  MoverUser.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _nickname = json['nickname'],
      _iconUrl = json['iconUrl'],
      _languagesAsISO639 = json['languagesAsISO639']?.cast<String>(),
      _email = json['email'],
      _discordID = json['discordID'],
      _wallet = json['wallet'],
      _firebaseTokenID = json['firebaseTokenID'],
      _extended = json['extended'],
      _company = json['company'],
      _rating = (json['rating'] as num?)?.toDouble(),
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'nickname': _nickname, 'iconUrl': _iconUrl, 'languagesAsISO639': _languagesAsISO639, 'email': _email, 'discordID': _discordID, 'wallet': _wallet, 'firebaseTokenID': _firebaseTokenID, 'extended': _extended, 'company': _company, 'rating': _rating, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "moverUser.id");
  static final QueryField NICKNAME = QueryField(fieldName: "nickname");
  static final QueryField ICONURL = QueryField(fieldName: "iconUrl");
  static final QueryField LANGUAGESASISO639 = QueryField(fieldName: "languagesAsISO639");
  static final QueryField EMAIL = QueryField(fieldName: "email");
  static final QueryField DISCORDID = QueryField(fieldName: "discordID");
  static final QueryField WALLET = QueryField(fieldName: "wallet");
  static final QueryField FIREBASETOKENID = QueryField(fieldName: "firebaseTokenID");
  static final QueryField EXTENDED = QueryField(fieldName: "extended");
  static final QueryField COMPANY = QueryField(fieldName: "company");
  static final QueryField RATING = QueryField(fieldName: "rating");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MoverUser";
    modelSchemaDefinition.pluralName = "MoverUsers";
    
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
      key: MoverUser.NICKNAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.ICONURL,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.LANGUAGESASISO639,
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.EMAIL,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.DISCORDID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.WALLET,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.FIREBASETOKENID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.EXTENDED,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.COMPANY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.RATING,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
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

class _MoverUserModelType extends ModelType<MoverUser> {
  const _MoverUserModelType();
  
  @override
  MoverUser fromJson(Map<String, dynamic> jsonData) {
    return MoverUser.fromJson(jsonData);
  }
}