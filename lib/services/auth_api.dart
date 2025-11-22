import 'package:dio/dio.dart';
import 'package:todolist_app/models/auth_models.dart';
import 'package:todolist_app/services/api_client.dart';

class AuthApi {
  AuthApi() : _dio = ApiClient().dio;

  final Dio _dio;

  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return AuthUser.fromJson(data);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final json = response.data as Map<String, dynamic>;
      final loginResponse = LoginResponse.fromJson(json);

      return loginResponse;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<RefreshTokenResponse> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/refresh-token',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'skipRefresh': true}),
      );

      final json = response.data as Map<String, dynamic>;
      return RefreshTokenResponse.fromJson(json);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> logout({required String refreshToken}) async {
    try {
      await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
    } on DioException catch (e) {
      rethrow;
    }
  }
}
