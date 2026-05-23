import '../../../../core/constants/end_points.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  /// POST /api/auth/login → { token, user }
  Future<AuthSessionModel> login(String email, String password);

  /// POST /api/auth/register → 201 { message }
  Future<void> register(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this.api);
  final ApiClient api;

  @override
  Future<AuthSessionModel> login(String email, String password) async {
    final response = await api.post(
      EndPoints.authLogin,
      body: {'email': email, 'password': password},
    );
    return AuthSessionModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<void> register(String name, String email, String password) async {
    await api.post(
      EndPoints.authRegister,
      body: {'name': name, 'email': email, 'password': password},
    );
  }
}
