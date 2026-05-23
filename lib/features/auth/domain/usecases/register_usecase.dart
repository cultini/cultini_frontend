import '../repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this.repository);
  final AuthRepository repository;

  Future<void> call({
    required String name,
    required String email,
    required String password,
  }) =>
      repository.register(name: name, email: email, password: password);
}
