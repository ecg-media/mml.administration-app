import 'package:cross_local_storage/cross_local_storage.dart';

/// Service that handles data of the local storage for the app.
///
/// Do not store critical information in this service. For crtitical information use [SecureStorageService]
class LocalStorageService {
  /// Instance of the local storage service.
  static final LocalStorageService _instance = LocalStorageService._();

  /// Key under which the app key is persisted.
  static const String userIdKey = 'userId';

  /// Instance of the lcoal storage plugin to access the data from the
  /// local storage.
  late LocalStorageInterface _storage;

  /// Private constructor of the service.
  LocalStorageService._() {
    _initLocalStorage();
  }

  void _initLocalStorage() async {
    _storage = await LocalStorage.getInstance();
  }

  /// Returns the singleton instance of the [LocalStorageService].
  static LocalStorageService getInstance() {
    return _instance;
  }

  /// Returns the value persisted under the given [key].
  String? get(String key) {
    return _storage.get(key);
  }

  /// Returns a boolean, that indicates whether a value is persisted under
  /// the given [key] or not.
  bool has(String key) {
    return _storage.containsKey(key);
  }

  /// Stores the [value] under the given [key].
  Future<void> set(String key, String value) async {
    await _storage.setString(key, value);
  }

  /// Deletes the value under the given [key] from the secure storage.
  Future<void> delete(String key) async {
    await _storage.remove(key);
  }
}
