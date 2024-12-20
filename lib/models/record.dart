import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/extensions/datetime.dart';
import 'package:mml_admin/extensions/flag.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';

part 'record.g.dart';

/// Record model that holds all information of a record.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Record extends ModelBase {
  /// Id of the client.
  final String? recordId;

  /// Title of the record.
  String? title;

  /// Track number of the record.
  int? trackNumber;

  /// The date the record was created..
  DateTime? date;

  /// The duration of the record in milliseconds.
  double duration;

  /// The artists or null if no one provided.
  String? artist;

  /// Genre of the record or null if no one provided.
  String? genre;

  /// Album of the record or null if no one provided.
  String? album;

  /// Language of the record or null if no one provided.
  String? language;

  /// The bitrate in kbit/s of the record.
  int? bitrate;

  /// The cover image of the record.
  String? cover;

  /// Indicates whether the record is locked for some operations on records..
  bool? locked;

  /// List of groups the client is assigned to.
  List<Group> groups = [];

  /// Creates a new record instance with the given values.
  Record({
    required this.recordId,
    this.title,
    this.trackNumber,
    this.date,
    this.duration = 0,
    this.album,
    this.artist,
    this.genre,
    this.language,
    this.bitrate,
    this.cover,
    this.locked,
    super.isDeletable,
    List<Group>? groups,
  }) {
    this.groups = groups ?? [];
  }

  /// Converts a json object/map to the record model.
  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  /// Converts the current record model to a json object/map.
  Map<String, dynamic> toJson() => _$RecordToJson(this);

  @override
  String getDisplayDescription() {
    final tn = trackNumber != null ? '$trackNumber - ' : '';
    return "$tn$title";
  }

  @override
  dynamic getIdentifier() {
    return recordId;
  }

  @override
  String? getSubtitle(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    return artist ?? locales.unknown;
  }

  @override
  String? getMetadata(BuildContext context) {
    int seconds = ((duration / 1000) % 60).toInt();
    int minutes = ((duration / (1000 * 60)) % 60).toInt();
    int hours = ((duration / (1000 * 60 * 60)) % 24).toInt();
    return "${_valueString(hours)}:${_valueString(minutes)}:${_valueString(seconds)}";
  }

  @override
  String? getSubMetadata(BuildContext context) {
    var g = genre ?? '';

    var lang = '';
    if (language != null) {
      lang = "${language?.asFlag().join(' ')}";
    }

    return "$g${lang.isEmpty ? '' : ' '}$lang";
  }

  @override
  List<ModelBase>? getTags() {
    return groups;
  }

  @override
  String? getGroup(BuildContext context) {
    return '${DateFormat.yMd().format(date!)} - ${date!.weekdayName()}${album?.isNotEmpty ?? false ? ':' : ''} $album';
  }

  @override
  String? getDisplayDescriptionSuffix(BuildContext context) {
    return bitrate != null ? "$bitrate kbit/s" : null;
  }

  @override
  Widget? getAvatar(BuildContext context) {
    if (cover != null && cover!.isNotEmpty) {
      return Image.memory(
        Uint8List.fromList(
          base64.decode(cover!),
        ),
      );
    }
    return const Icon(Symbols.music_note);
  }

  @override
  Widget? getSecureState(BuildContext context) {
    return Icon(
      Symbols.lock_open,
      size: 10,
      color: (locked ?? false) ? Theme.of(context).colorScheme.secondary : null
    );
  }

  /// Adds a 0 before [value] if [value] is smaller than ten.
  String _valueString(int value) {
    return value < 10 ? "0$value" : "$value";
  }
}
