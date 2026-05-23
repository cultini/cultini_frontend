import '../entities/doc_entry_entity.dart';
import '../repositories/docs_repository.dart';

class GetDocsUseCase {
  const GetDocsUseCase(this.repository);
  final DocsRepository repository;

  Future<List<DocEntryEntity>> call() => repository.getEntries();
}
