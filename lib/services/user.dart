import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/models/user.dart';
import 'package:mml_admin/services/api.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/secure_storage.dart';

class UserService {
  static final UserService _instance = UserService._();

  final ApiService _apiService = ApiService.getInstance();
  final SecureStorageService _storage = SecureStorageService.getInstance();

  UserService._();

  static UserService getInstance() {
    return _instance;
  }

  Future<List<User>> getUsers(/* user filter*/) async {
    throw UnimplementedError();
  }

  Future<User> getUser(int id) async {
    throw UnimplementedError();
  }

  Future<bool> deleteUser(int id) async {
    throw UnimplementedError();
  }

  Future<bool> createUser() async {
    throw UnimplementedError();
  }

  Future<bool> updateUser(int? id) async {
    throw UnimplementedError();
  }

  Future login(String username, String password) async {
    var clientId = await _storage.get(SecureStorageService.clientIdStorageKey);

    Response<Map> response = await _apiService.request(
      '/identity/connect/token',
      data: {
        'grant_type': 'password',
        'client_id': clientId,
        'scope': 'offline_access',
        'username': username,
        'password': password
      },
      options: Options(
        method: 'POST',
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      await _storage.set(
        SecureStorageService.accessTokenStorageKey,
        response.data?['access_token'],
      );
      await _storage.set(
        SecureStorageService.refreshTokenStorageKey,
        response.data?['refresh_token'],
      );
    }
  }

  Future logout() async {
    try {
      var dio = Dio();
      _apiService.addRequestOptionsInterceptor(dio);
      _apiService.initClientBadCertificateCallback(dio);
      await dio.request(
        '/identity/connect/logout',
        data: {},
        options: Options(
          method: 'POST',
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
    } catch (e) {
      // Ignore all errors, since logout will always be done by expiration of tokens.
    } finally {
      await _storage.delete(SecureStorageService.accessTokenStorageKey);
      await _storage.delete(SecureStorageService.refreshTokenStorageKey);

      NavigatorState state = RouterService.getInstance().navigatorKey.currentState!;
      state.pushReplacementNamed('/login');
    }
  }

  Future<User?> getUserInfo() async {
    if (await _storage.has(SecureStorageService.accessTokenStorageKey)) {
      var response = await _apiService.request(
        '/identity/connect/userinfo',
        options: Options(method: 'GET'),
      );

      return User.fromJson(response.data);
    }

    return null;
  }
}
