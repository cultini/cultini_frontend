import 'auth_user_model.dart';

/// Mirrors the Node login response: `{ token, user: { id, name, email } }`.
class AuthSessionModel {
  const AuthSessionModel({required this.token, required this.user});

  final String token;
  final AuthUserModel user;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) =>
      AuthSessionModel(
        token: json['token'] as String? ?? '',
        user: AuthUserModel.fromJson(
          (json['user'] as Map?)?.cast<String, dynamic>() ??
              const <String, dynamic>{},
        ),
      );
}
