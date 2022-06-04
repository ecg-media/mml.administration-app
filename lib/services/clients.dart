import 'package:dio/dio.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/api.dart';
import 'package:mml_admin/services/secure_storage.dart';

/// Service that handles the clients data of the server.
class ClientService {
  /// Instance of the client service.
  static final ClientService _instance = ClientService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Instance of the [SecureStorageService] to handle data in the secure
  /// storage.
  final SecureStorageService _storage = SecureStorageService.getInstance();

  /// Private constructor of the service.
  ClientService._();

  /// Returns the singleton instance of the [ClientService].
  static ClientService getInstance() {
    return _instance;
  }

  /// Returns a list of clients with the amount of [take] that match the given
  /// [filter] starting from the [offset].
  Future<ModelList> getClients(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/identity/client/list',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(method: 'GET'),
    );

    var items = (response.data["items"] as List<dynamic>)
        .map((item) => Client.fromJson(item))
        .toList();
    return ModelList(items, offset ?? 0, response.data["totalCount"]);
  }

  /// Deletes the clients with the given [clientIds] on the server.
  Future<void> deleteClients(clientIds) async {
    await _apiService.request(
      '/identity/client/deleteList',
      data: clientIds,
      options: Options(method: 'POST'),
    );
  }

  /// Updates the given [Client] on the server.
  Future<void> updateClient(Client client) async {
    await _apiService.request(
      '/identity/client',
      data: client.toJson(),
      options: Options(method: 'POST'),
    );
  }
}
