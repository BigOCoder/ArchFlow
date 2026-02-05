import 'user_model.dart';

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final String? message;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
      if (message != null) 'message': message,
    };
  }
}
