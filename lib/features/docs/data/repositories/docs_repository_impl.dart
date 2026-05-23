import '../../../../core/network/network_info.dart';
import '../../domain/entities/doc_entry_entity.dart';
import '../../domain/repositories/docs_repository.dart';
import '../datasources/docs_local_data_source.dart';
import '../datasources/docs_remote_data_source.dart';

class DocsRepositoryImpl implements DocsRepository {
  DocsRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  // ignore: unused_field — scaffolded for when a documentation endpoint exists.
  final DocsRemoteDataSource remote;
  final DocsLocalDataSource local;
  // ignore: unused_field — used once [remote] is wired (online-first fetch).
  final NetworkInfo networkInfo;

  @override
  Future<List<DocEntryEntity>> getEntries() async {
    // Mock-only today. To go live: when networkInfo.isConnected, fetch from
    // [remote], cache, and fall back to [local] on failure.
    return local.getEntries();
  }
}
