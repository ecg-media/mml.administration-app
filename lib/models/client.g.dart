// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      clientId: json['clientId'] as String?,
      displayName: json['displayName'] as String?,
      isDeletable: json['isDeletable'] as bool? ?? true,
    );

Map<String, dynamic> _$ClientToJson(Client instance) {
  final val = <String, dynamic>{
    'isDeletable': instance.isDeletable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('clientId', instance.clientId);
  writeNotNull('displayName', instance.displayName);
  return val;
}