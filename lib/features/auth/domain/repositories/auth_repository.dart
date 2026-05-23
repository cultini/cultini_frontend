import '../entities/auth_user_entity.dart';

/// Backend interface for authentication. The HTTP implementation talks to the
/// Node/Express backend; swap it for a mock by re-binding in the DI container.
abstract class AuthRepository {
  /// Logs in and persists the JWT + user locally. Throws a [Failure] on error.
  Future<AuthUserEntity> login({
    required String email,
    required String password,
  });

  /// Registers a new account. Backend returns no token, so the user then logs in.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  /// Clears the persisted token + cached user.
  Future<void> logout();

  /// The cached user from a previous login, or null if signed out.
  Future<AuthUserEntity?> currentUser();

  /// Whether a token is currently persisted.
  bool get isLoggedIn;
}
