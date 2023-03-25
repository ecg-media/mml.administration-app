// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livestream.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Livestream _$LivestreamFromJson(Map<String, dynamic> json) => Livestream(
      livestreamId: json['livestreamId'] as String?,
      displayName: json['displayName'] as String?,
      url: json['url'] as String?,
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
      isDeletable: json['isDeletable'] as bool? ?? true,
    );

Map<String, dynamic> _$LivestreamToJson(Livestream instance) {
  final val = <String, dynamic>{
    'isDeletable': instance.isDeletable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('livestreamId', instance.livestreamId);
  writeNotNull('displayName', instance.displayName);
  writeNotNull('url', instance.url);
  val['groups'] = instance.groups.map((e) => e.toJson()).toList();
  return val;
}
