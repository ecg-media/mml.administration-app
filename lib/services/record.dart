import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mml_admin/extensions/multipartfile.dart';
import 'package:mml_admin/models/album.dart';
import 'package:mml_admin/models/artist.dart';
import 'package:mml_admin/models/genre.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/record.dart';
import 'package:mml_admin/services/api.dart';

/// Service that handles the records data of the server.
class RecordService {
  /// Instance of the record service.
  static final RecordService _instance = RecordService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Private constructor of the service.
  RecordService._();

  /// Returns the singleton instance of the [RecordService].
  static RecordService getInstance() {
    return _instance;
  }

  /// Uploads a [file] with the given [fileName] to the server.
  Future upload(File file, String fileName) async {
    final lastModified = await file.lastModified();
    FormData formData = FormData.fromMap(
      {
        "file": MultipartFileExtended.fromFileSync(
          file.path,
          filename: fileName,
        )
      },
    );
    formData.fields.add(
      MapEntry(
        'LastModifiedDate',
        lastModified.toString(),
      ),
    );
    await _apiService.request(
      '/media/upload',
      data: formData,
      options: Options(method: 'POST'),
    );
  }

  /// Returns a list of records with the amount of [take] that match the given
  /// [filter] starting from the [offset].
  Future<ModelList> getRecords(
    String? filter,
    int? offset,
    int? take,
    ID3TagFilter? tagFilter,
  ) async {
    var params = <String, String?>{};

    if (filter != null) {
      params['filter'] = filter;
    }

    if (offset != null) {
      params['skip'] = offset.toString();
    }

    if (take != null) {
      params['take'] = take.toString();
    }

    var response = await _apiService.request(
      '/media/record/list',
      queryParameters: params,
      data: tagFilter != null ? tagFilter.toJson() : {},
      options: Options(
        method: 'POST',
      ),
    );

    return ModelList(
      List<Record>.from(
        response.data['items'].map((item) => Record.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Returns a list of artists with the amount of [take] starting from the [offset] and with the passed [filter],
  Future<ModelList> getArtists(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/record/artists',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Artist>.from(
        response.data['items'].map((item) => Artist.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Returns a list of albums with the amount of [take] starting from the [offset] and with the passed [filter],
  Future<ModelList> getAlbums(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/record/albums',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Album>.from(
        response.data['items'].map((item) => Album.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Returns a list of genres with the amount of [take] starting from the [offset] with the passed [filter],
  Future<ModelList> getGenres(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/record/genres',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Genre>.from(
        response.data['items'].map((item) => Genre.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }
}
