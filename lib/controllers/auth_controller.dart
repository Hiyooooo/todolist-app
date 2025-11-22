import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:todolist_app/models/auth_models.dart';
import 'package:todolist_app/routes/app_routes.dart';
import 'package:todolist_app/services/api_client.dart';
import 'package:todolist_app/services/auth_api.dart';

class AuthController extends GetxController {
  final AuthApi _authApi = AuthApi();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys untuk secure storage
  static const _keyAccessToken = 'accessToken';
  static const _keyRefreshToken = 'refreshToken';
  static const _keyUserId = 'userId';
  static const _keyUserName = 'userName';
  static const _keyUserEmail = 'userEmail';

  // State reaktif
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final Rx<AuthUser?> _user = Rx<AuthUser?>(null);
  final RxString _accessToken = ''.obs;
  final RxString _refreshToken = ''.obs;

  AuthUser? get user => _user.value;
  String get accessToken => _accessToken.value;
  String get refreshToken => _refreshToken.value;

  @override
  void onInit() {
    super.onInit();
    _setupDioInterceptor();
    tryAutoLogin();
  }

  /// Coba baca token + user dari storage dan langsung ke halaman todos.
  Future<void> tryAutoLogin() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final storedAccessToken = await _storage.read(key: _keyAccessToken);
      final storedRefreshToken = await _storage.read(key: _keyRefreshToken);

      if (storedAccessToken == null || storedRefreshToken == null) {
        // Belum pernah login
        isLoading.value = false;
        return;
      }

      final userId = await _storage.read(key: _keyUserId);
      final userName = await _storage.read(key: _keyUserName);
      final userEmail = await _storage.read(key: _keyUserEmail);

      if (userId != null && userName != null && userEmail != null) {
        _user.value = AuthUser(id: userId, name: userName, email: userEmail);
      }

      _accessToken.value = storedAccessToken;
      _refreshToken.value = storedRefreshToken;

      // Set header Authorization global
      ApiClient().setAccessToken(storedAccessToken);

      // Langsung pindah ke halaman todos
      Get.offAllNamed(AppRoutes.todos);
    } catch (e) {
      // Kalau gagal auto-login, biarkan user login manual
      errorMessage.value = 'Gagal memuat sesi, silakan login ulang.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Login ke backend.
  ///
  /// Akan:
  /// - Memanggil AuthApi.login
  /// - Menyimpan token + user ke storage
  /// - Set Authorization header
  /// - Navigate ke halaman todos
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email dan password wajib diisi.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authApi.login(email: email, password: password);

      final loginData = response.data;
      final tokens = loginData.tokens;
      final user = loginData.user;

      _user.value = user;
      _accessToken.value = tokens.accessToken;
      _refreshToken.value = tokens.refreshToken;

      // Set Authorization header global
      ApiClient().setAccessToken(tokens.accessToken);

      // Simpan ke secure storage
      await _saveSession(user, tokens);

      // Pindah ke halaman todos (hapus stack sebelumnya)
      Get.offAllNamed(AppRoutes.todos);
    } catch (e) {
      errorMessage.value = _mapErrorToMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout:
  /// - panggil /auth/logout (opsional tapi bagus)
  /// - hapus storage
  /// - reset state
  /// - kembali ke halaman login
  Future<void> logout() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final currentRefreshToken = _refreshToken.value;
      if (currentRefreshToken.isNotEmpty) {
        await _authApi.logout(refreshToken: currentRefreshToken);
      }
    } catch (_) {
      // Kalau gagal logout di server, tetap lanjut clear session di client.
    } finally {
      await _clearSession();
      isLoading.value = false;

      // Balik ke login
      Get.offAllNamed(AppRoutes.login);
    }
  }

  /// Simpan token + user ke secure storage.
  Future<void> _saveSession(AuthUser user, AuthTokens tokens) async {
    await _storage.write(key: _keyAccessToken, value: tokens.accessToken);
    await _storage.write(key: _keyRefreshToken, value: tokens.refreshToken);
    await _storage.write(key: _keyUserId, value: user.id);
    await _storage.write(key: _keyUserName, value: user.name);
    await _storage.write(key: _keyUserEmail, value: user.email);
  }

  /// Hapus semua data sesi.
  Future<void> _clearSession() async {
    _user.value = null;
    _accessToken.value = '';
    _refreshToken.value = '';
    ApiClient().setAccessToken(null);

    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyUserName);
    await _storage.delete(key: _keyUserEmail);
  }

  String _mapErrorToMessage(Object e) {
    if (e is DioException) {
      final response = e.response;
      if (response != null) {
        final data = response.data;
        if (data is Map && data['message'] is String) {
          return data['message'] as String;
        }
      }
      return 'Gagal login: ${e.message ?? 'Terjadi kesalahan jaringan'}';
    }
    return 'Terjadi kesalahan, silakan coba lagi.';
  }

  /// Dipanggil oleh interceptor ketika dapat 401.
  /// Coba refresh access token menggunakan refreshToken yang tersimpan.
  ///
  /// Return:
  /// - AuthTokens baru kalau berhasil
  /// - null kalau gagal (refresh token invalid/expired)
  Future<AuthTokens?> tryRefreshTokens() async {
    final currentRefreshToken = _refreshToken.value;
    if (currentRefreshToken.isEmpty) {
      return null;
    }

    try {
      final res = await _authApi.refreshToken(
        refreshToken: currentRefreshToken,
      );

      final tokens = res.data.tokens;

      _accessToken.value = tokens.accessToken;
      _refreshToken.value = tokens.refreshToken;

      // Update Authorization header global
      ApiClient().setAccessToken(tokens.accessToken);

      // Simpan ke storage (kalau user sudah ada)
      if (_user.value != null) {
        await _saveSession(_user.value!, tokens);
      } else {
        await _storage.write(key: _keyAccessToken, value: tokens.accessToken);
        await _storage.write(key: _keyRefreshToken, value: tokens.refreshToken);
      }

      return tokens;
    } catch (_) {
      return null;
    }
  }

  /// Dipanggil ketika refresh token gagal → hapus sesi lokal dan balik ke login.
  Future<void> forceLogoutToLogin() async {
    await _clearSession();
    Get.offAllNamed(AppRoutes.login);
  }

  void _setupDioInterceptor() {
    final dio = ApiClient().dio;

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (error, handler) async {
          final response = error.response;
          final requestOptions = error.requestOptions;

          // Cek apakah request ini diminta untuk skip refresh (misalnya refresh-token itu sendiri)
          final shouldSkipRefresh = requestOptions.extra['skipRefresh'] == true;

          // Kalau 401 dan bukan request yang di-skip, coba refresh token
          if (response?.statusCode == 401 && !shouldSkipRefresh) {
            try {
              // Tandai supaya request ini tidak memicu refresh lagi jika gagal setelah retry
              requestOptions.extra['skipRefresh'] = true;

              final newTokens = await tryRefreshTokens();

              if (newTokens != null) {
                // Update Authorization header untuk request yang akan diulang
                requestOptions.headers['Authorization'] =
                    'Bearer ${newTokens.accessToken}';

                // Ulangi request yang gagal
                final cloneResponse = await dio.fetch(requestOptions);

                return handler.resolve(cloneResponse);
              } else {
                // Refresh gagal → paksa user ke halaman login
                await forceLogoutToLogin();
              }
            } catch (_) {
              // Kalau ada problem saat refresh, paksa logout juga
              await forceLogoutToLogin();
            }
          }

          // Kalau bukan 401 atau skipRefresh, teruskan error apa adanya
          return handler.next(error);
        },
      ),
    );
  }
}
