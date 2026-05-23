import '../../../../core/network/api_client.dart';
import '../models/doc_entry_model.dart';

/// Scaffold for a future documentation endpoint. No backend route exists yet,
/// so [DocsRepositoryImpl] uses the local mock; wire this up (and add the path
/// to EndPoints) once the backend exposes the corpus.
abstract class DocsRemoteDataSource {
  Future<List<DocEntryModel>> getEntries();
}

class DocsRemoteDataSourceImpl implements DocsRemoteDataSource {
  DocsRemoteDataSourceImpl(this.api);
  final ApiClient api;

  @override
  Future<List<DocEntryModel>> getEntries() async {
    // Example for later:
    //   final r = await api.get(EndPoints.docs);
    //   return (r['data'] as List).map((e) => DocEntryModel.fromJson(e)).toList();
    throw UnimplementedError('No documentation endpoint yet.');
  }
}
