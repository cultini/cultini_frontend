import '../entities/doc_entry_entity.dart';

abstract class DocsRepository {
  /// All documentation entries. Filtering (search/category/wilaya) happens in
  /// the presentation layer over this list.
  Future<List<DocEntryEntity>> getEntries();
}
