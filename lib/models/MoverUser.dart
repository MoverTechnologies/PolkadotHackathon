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
  final String? _walletID;
  final String? _firebaseTokenID;
  final String? _iconUrl;
  final List<String>? _languagesAsISO639;
  final String? _email;
  final String? _name;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get walletID {
    return _walletID;
  }
  
  String? get firebaseTokenID {
    return _firebaseTokenID;
  }
  
  String? get iconUrl {
    return _iconUrl;
  }
  
  List<String>? get languagesAsISO639 {
    return _languagesAsISO639;
  }
  
  String? get email {
    return _email;
  }
  
  String? get name {
    return _name;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const MoverUser._internal({required this.id, walletID, firebaseTokenID, iconUrl, languagesAsISO639, email, name, createdAt, updatedAt}): _walletID = walletID, _firebaseTokenID = firebaseTokenID, _iconUrl = iconUrl, _languagesAsISO639 = languagesAsISO639, _email = email, _name = name, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory MoverUser({String? id, String? walletID, String? firebaseTokenID, String? iconUrl, List<String>? languagesAsISO639, String? email, String? name}) {
    return MoverUser._internal(
      id: id == null ? UUID.getUUID() : id,
      walletID: walletID,
      firebaseTokenID: firebaseTokenID,
      iconUrl: iconUrl,
      languagesAsISO639: languagesAsISO639 != null ? List<String>.unmodifiable(languagesAsISO639) : languagesAsISO639,
      email: email,
      name: name);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MoverUser &&
      id == other.id &&
      _walletID == other._walletID &&
      _firebaseTokenID == other._firebaseTokenID &&
      _iconUrl == other._iconUrl &&
      DeepCollectionEquality().equals(_languagesAsISO639, other._languagesAsISO639) &&
      _email == other._email &&
      _name == other._name;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("MoverUser {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("walletID=" + "$_walletID" + ", ");
    buffer.write("firebaseTokenID=" + "$_firebaseTokenID" + ", ");
    buffer.write("iconUrl=" + "$_iconUrl" + ", ");
    buffer.write("languagesAsISO639=" + (_languagesAsISO639 != null ? _languagesAsISO639!.toString() : "null") + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  MoverUser copyWith({String? id, String? walletID, String? firebaseTokenID, String? iconUrl, List<String>? languagesAsISO639, String? email, String? name}) {
    return MoverUser._internal(
      id: id ?? this.id,
      walletID: walletID ?? this.walletID,
      firebaseTokenID: firebaseTokenID ?? this.firebaseTokenID,
      iconUrl: iconUrl ?? this.iconUrl,
      languagesAsISO639: languagesAsISO639 ?? this.languagesAsISO639,
      email: email ?? this.email,
      name: name ?? this.name);
  }
  
  MoverUser.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _walletID = json['walletID'],
      _firebaseTokenID = json['firebaseTokenID'],
      _iconUrl = json['iconUrl'],
      _languagesAsISO639 = json['languagesAsISO639']?.cast<String>(),
      _email = json['email'],
      _name = json['name'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'walletID': _walletID, 'firebaseTokenID': _firebaseTokenID, 'iconUrl': _iconUrl, 'languagesAsISO639': _languagesAsISO639, 'email': _email, 'name': _name, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "moverUser.id");
  static final QueryField WALLETID = QueryField(fieldName: "walletID");
  static final QueryField FIREBASETOKENID = QueryField(fieldName: "firebaseTokenID");
  static final QueryField ICONURL = QueryField(fieldName: "iconUrl");
  static final QueryField LANGUAGESASISO639 = QueryField(fieldName: "languagesAsISO639");
  static final QueryField EMAIL = QueryField(fieldName: "email");
  static final QueryField NAME = QueryField(fieldName: "name");
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
      key: MoverUser.WALLETID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.FIREBASETOKENID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.ICONURL,
      isRequired: false,
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
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MoverUser.NAME,
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

class _MoverUserModelType extends ModelType<MoverUser> {
  const _MoverUserModelType();
  
  @override
  MoverUser fromJson(Map<String, dynamic> jsonData) {
    return MoverUser.fromJson(jsonData);
  }
}