import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String name;
  final String email;

  const AuthUser({required this.id, required this.name, required this.email});

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }

  @override
  List<Object?> get props => [id, name, email];
}

/// Representasi pasangan akses token & refresh token.
class AuthTokens {
  final String accessToken;
  final String refreshToken;

  const AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  AuthTokens copyWith({String? accessToken, String? refreshToken}) {
    return AuthTokens(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class LoginData {
  final AuthTokens tokens;
  final AuthUser user;

  const LoginData({required this.tokens, required this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      tokens: AuthTokens(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
      ),
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': tokens.accessToken,
      'refreshToken': tokens.refreshToken,
      'user': user.toJson(),
    };
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final LoginData data;
  final dynamic meta;

  const LoginResponse({
    required this.success,
    required this.message,
    required this.data,
    this.meta,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: LoginData.fromJson(json['data'] as Map<String, dynamic>),
      meta: json['meta'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'meta': meta,
    };
  }
}

class RefreshTokenData {
  final AuthTokens tokens;

  const RefreshTokenData({required this.tokens});

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) {
    return RefreshTokenData(tokens: AuthTokens.fromJson(json));
  }

  Map<String, dynamic> toJson() {
    return tokens.toJson();
  }
}

class RefreshTokenResponse {
  final bool success;
  final String message;
  final RefreshTokenData data;
  final dynamic meta;

  const RefreshTokenResponse({
    required this.success,
    required this.message,
    required this.data,
    this.meta,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: RefreshTokenData.fromJson(json['data'] as Map<String, dynamic>),
      meta: json['meta'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'meta': meta,
    };
  }
}
