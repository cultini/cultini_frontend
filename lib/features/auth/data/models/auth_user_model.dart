import '../../domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        // Node returns `id` on login; accept `_id` too for safety.
        id: (json['id'] ?? json['_id'] ?? '').toString(),
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
