import '../../../../core/constants/storage_keys.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/app_local_storage.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remote,
    required this.storage,
    required this.apiClient,
  });

  final AuthRemoteDataSource remote;
  final AppLocalStorage storage;
  final ApiClient apiClient;

  @override
  Future<AuthUserEntity> login({
    required String email,
    required String password,
  }) async {
    final session = await remote.login(email, password);
    await storage.setString(StorageKeys.accessToken, session.token);
    await storage.setJson(StorageKeys.cachedAccount, session.user.toJson());
    apiClient.setAccessToken(session.token);
    return session.user;
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) =>
      remote.register(name, email, password);

  @override
  Future<void> logout() async {
    await storage.removePref(StorageKeys.accessToken);
    await storage.removePref(StorageKeys.cachedAccount);
    apiClient.clearAccessToken();
  }

  @override
  Future<AuthUserEntity?> currentUser() async {
    final token = storage.getString(StorageKeys.accessToken);
    final json = storage.getJson(StorageKeys.cachedAccount);
    if (token == null || token.isEmpty || json == null) return null;
    apiClient.setAccessToken(token);
    return AuthUserModel.fromJson(json);
  }

  @override
  bool get isLoggedIn {
    final token = storage.getString(StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }
}
