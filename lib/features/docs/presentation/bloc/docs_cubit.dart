import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/doc_entry_entity.dart';
import '../../domain/usecases/get_docs_usecase.dart';

const Object _sentinel = Object();

class DocsState extends Equatable {
  const DocsState({
    this.all = const <DocEntryEntity>[],
    this.loading = false,
    this.error,
    this.query = '',
    this.category,
    this.wilaya,
  });

  final List<DocEntryEntity> all;
  final bool loading;
  final String? error;
  final String query;
  final DocCategory? category; // null = all categories
  final String? wilaya; // null/empty = all regions

  /// Entries after applying search + category + wilaya filters.
  List<DocEntryEntity> get filtered {
    final q = query.trim().toLowerCase();
    final w = wilaya?.trim().toLowerCase();
    return all.where((e) {
      final matchesQuery = q.isEmpty ||
          e.titre.toLowerCase().contains(q) ||
          e.contenu.toLowerCase().contains(q) ||
          e.termesAmazighs.any((t) => t.toLowerCase().contains(q));
      final matchesCategory = category == null || e.categorie == category;
      final matchesWilaya =
          w == null || w.isEmpty || e.region.toLowerCase().contains(w);
      return matchesQuery && matchesCategory && matchesWilaya;
    }).toList();
  }

  DocsState copyWith({
    List<DocEntryEntity>? all,
    bool? loading,
    String? error,
    String? query,
    Object? category = _sentinel,
    Object? wilaya = _sentinel,
  }) {
    return DocsState(
      all: all ?? this.all,
      loading: loading ?? this.loading,
      error: error,
      query: query ?? this.query,
      category:
          identical(category, _sentinel) ? this.category : category as DocCategory?,
      wilaya: identical(wilaya, _sentinel) ? this.wilaya : wilaya as String?,
    );
  }

  @override
  List<Object?> get props => [all, loading, error, query, category, wilaya];
}

class DocsCubit extends Cubit<DocsState> {
  DocsCubit(this.getDocs) : super(const DocsState());
  final GetDocsUseCase getDocs;

  Future<void> load({String? initialWilaya}) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final all = await getDocs();
      emit(DocsState(all: all, loading: false, wilaya: initialWilaya));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void setQuery(String value) => emit(state.copyWith(query: value));

  void setCategory(DocCategory? value) => emit(state.copyWith(category: value));

  void setWilaya(String? value) => emit(state.copyWith(wilaya: value));

  void clearFilters() => emit(state.copyWith(
        query: '',
        category: null,
        wilaya: null,
      ));
}
