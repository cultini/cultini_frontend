import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/storage/app_local_storage.dart';
import '../core/network/network_info.dart';
import '../core/network/api_client.dart';
import 'package:http/http.dart' as http;
import '../features/chat/data/datasources/chat_local_data_source.dart';
import '../features/chat/data/datasources/chat_remote_data_source.dart';
import '../features/chat/data/repositories/chat_repository_impl.dart';
import '../features/chat/domain/repositories/chat_repository.dart';
import '../features/chat/domain/usecases/get_chat_history_usecase.dart';
import '../features/chat/domain/usecases/send_chat_message_usecase.dart';
import '../features/chat/presentation/bloc/chat_bloc.dart';

import '../core/constants/end_points.dart';
import '../features/auth/data/datasource/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/presentation/blocs/auth_bloc.dart';
import '../features/docs/data/datasources/docs_local_data_source.dart';
import '../features/docs/data/datasources/docs_remote_data_source.dart';
import '../features/docs/data/repositories/docs_repository_impl.dart';
import '../features/docs/domain/repositories/docs_repository.dart';
import '../features/docs/domain/usecases/get_docs_usecase.dart';
import '../features/docs/presentation/bloc/docs_cubit.dart';
import '../features/contribution/data/datasources/contribution_local_data_source.dart';
import '../features/contribution/data/datasources/contribution_remote_data_source.dart';
import '../features/contribution/data/repositories/contribution_repository_impl.dart';
import '../features/contribution/domain/repositories/contribution_repository.dart';
import '../features/contribution/domain/usecases/submit_contribution_usecase.dart';
import '../features/contribution/presentation/bloc/contribution_cubit.dart';


final sl = GetIt.instance;

Future<void> init() async {
    await sl.reset();

  // ── External ───────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<AppLocalStorage>(
    () => AppLocalStorage(prefs: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // ── Core ───────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivity: sl<Connectivity>(),
      connectionChecker: sl<InternetConnection>(),
    ),
  );

  // Default ApiClient → Node/Express auth backend.
  sl.registerLazySingleton(
    () => ApiClient(client: sl<http.Client>(), networkInfo: sl<NetworkInfo>()),
  );
  // Named ApiClient → FastAPI Azetta RAG backend (the chat endpoint).
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      client: sl<http.Client>(),
      networkInfo: sl<NetworkInfo>(),
      baseUrlOverride: EndPoints.aiBaseUrl,
    ),
    instanceName: 'ai',
  );


  //! Data Sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(apiClient: sl<ApiClient>(instanceName: 'ai')),
  );
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(storage: sl<AppLocalStorage>()),
  );

  //! Repositories
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remote: sl<ChatRemoteDataSource>(),
      local: sl<ChatLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  //! UseCases
  sl.registerLazySingleton(() => GetChatHistoryUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton(() => SendChatMessageUseCase(sl<ChatRepository>()));

  //! Cubits / Blocs
  sl.registerFactory(
    () => ChatBloc(
      getHistory: sl<GetChatHistoryUseCase>(),
      sendMessage: sl<SendChatMessageUseCase>(),
    ),
  );


  // ── Auth (Node/Express backend) ──────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remote: sl<AuthRemoteDataSource>(),
        storage: sl<AppLocalStorage>(),
        apiClient: sl<ApiClient>(),
      ));
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl<LoginUseCase>(),
        registerUseCase: sl<RegisterUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
        authRepository: sl<AuthRepository>(),
      ));

  // ── Documentation (mock data; remote scaffolded) ─────────────────────────────
  sl.registerLazySingleton<DocsRemoteDataSource>(() => DocsRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<DocsLocalDataSource>(() => DocsLocalDataSourceImpl(sl<AppLocalStorage>()));
  sl.registerLazySingleton<DocsRepository>(() => DocsRepositoryImpl(remote: sl<DocsRemoteDataSource>(), local: sl<DocsLocalDataSource>(), networkInfo: sl<NetworkInfo>()));
  sl.registerLazySingleton(() => GetDocsUseCase(sl<DocsRepository>()));
  sl.registerFactory(() => DocsCubit(sl<GetDocsUseCase>()));

  // ── Contribution (POST /contributions → FastAPI Azetta backend) ──────────────
  sl.registerLazySingleton<ContributionRemoteDataSource>(
    () => ContributionRemoteDataSourceImpl(apiClient: sl<ApiClient>(instanceName: 'ai')),
  );
  sl.registerLazySingleton<ContributionLocalDataSource>(() => ContributionLocalDataSourceImpl(sl<AppLocalStorage>()));
  sl.registerLazySingleton<ContributionRepository>(() => ContributionRepositoryImpl(
        remote: sl<ContributionRemoteDataSource>(),
        local: sl<ContributionLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ));
  sl.registerLazySingleton(() => SubmitContributionUseCase(sl<ContributionRepository>()));
  sl.registerFactory(() => ContributionCubit(sl<SubmitContributionUseCase>()));
}
