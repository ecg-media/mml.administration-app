import 'package:dio/dio.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/api.dart';

/// Service that handles the clients data of the server.
class ClientService {
  /// Instance of the client service.
  static final ClientService _instance = ClientService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

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

    return ModelList(
        List<Client>.from(
          response.data['items'].map((item) => Client.fromJson(item)),
        ),
        offset ?? 0,
        response.data["totalCount"]);
  }

  /// Deletes the clients with the given [clientIds] on the server.
  Future<void> deleteClients<String>(List<String> clientIds) async {
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

  /// Loads the client with the given [id] from the server.
  ///
  /// Returns the [Client] instance or null if the client was not found.
  Future<Client> getClient(String id) async {
    var response = await _apiService.request(
      '/identity/client/$id',
      options: Options(
        method: 'GET',
      ),
    );

    return Client.fromJson(response.data);
  }
}
