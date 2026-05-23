import 'package:equatable/equatable.dart';

/// The authenticated user as returned by the Node/Express backend
/// (`{ id, name, email }`).
class AuthUserEntity extends Equatable {
  const AuthUserEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  /// Up to two uppercase initials for the avatar.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  List<Object?> get props => [id, name, email];
}
