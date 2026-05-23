import '../../../../core/data/dummy_data.dart';
import '../../../../core/storage/app_local_storage.dart';
import '../models/doc_entry_model.dart';

abstract class DocsLocalDataSource {
  Future<List<DocEntryModel>> getEntries();
}

/// Mock source seeded from [DummyData] (corpus adapted from cultini_AI/corpus).
class DocsLocalDataSourceImpl implements DocsLocalDataSource {
  DocsLocalDataSourceImpl(this.storage);
  final AppLocalStorage storage;

  @override
  Future<List<DocEntryModel>> getEntries() async => DummyData.docEntries;
}
