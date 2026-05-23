import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this.repository);
  final AuthRepository repository;

  Future<AuthUserEntity> call({
    required String email,
    required String password,
  }) =>
      repository.login(email: email, password: password);
}
