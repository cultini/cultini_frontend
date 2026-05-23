// Unit tests for Cultini's core logic: documentation filtering, the chat
// metrics parser, and form validators. Pure Dart — no widget/DI plumbing.

import 'package:flutter_test/flutter_test.dart';

import 'package:help_app/core/validators/validators.dart';
import 'package:help_app/features/chat/data/models/chat_metrics_model.dart';
import 'package:help_app/features/docs/domain/entities/doc_entry_entity.dart';
import 'package:help_app/features/docs/presentation/bloc/docs_cubit.dart';

DocEntryEntity _entry({
  required String id,
  required String titre,
  required String region,
  required DocCategory categorie,
  List<String> termes = const [],
}) =>
    DocEntryEntity(
      id: id,
      titre: titre,
      contenu: 'contenu de $titre',
      region: region,
      categorie: categorie,
      termesAmazighs: termes,
      source: 'test',
    );

void main() {
  group('DocsState.filtered', () {
    final entries = [
      _entry(id: '1', titre: 'Le Yaz', region: 'Tamanrasset', categorie: DocCategory.motif, termes: ['aza']),
      _entry(id: '2', titre: 'La fibule', region: 'Tizi Ouzou', categorie: DocCategory.bijou, termes: ['tabzimt']),
      _entry(id: '3', titre: 'Le tifinagh', region: 'Afrique du Nord', categorie: DocCategory.ecriture),
    ];
    final base = DocsState(all: entries);

    test('no filters returns everything', () {
      expect(base.filtered.length, 3);
    });

    test('category filter', () {
      expect(base.copyWith(category: DocCategory.bijou).filtered.single.id, '2');
    });

    test('wilaya filter matches region (case-insensitive, substring)', () {
      expect(base.copyWith(wilaya: 'tizi ouzou').filtered.single.id, '2');
    });

    test('query matches title or amazigh term', () {
      expect(base.copyWith(query: 'yaz').filtered.single.id, '1');
      expect(base.copyWith(query: 'tabzimt').filtered.single.id, '2');
    });

    test('filters combine', () {
      final s = base.copyWith(category: DocCategory.motif, wilaya: 'Tamanrasset');
      expect(s.filtered.single.id, '1');
      expect(base.copyWith(category: DocCategory.bijou, wilaya: 'Tamanrasset').filtered, isEmpty);
    });
  });

  group('ChatMetricsModel.fromJson', () {
    test('parses nested cultural_coverage + distinct scores', () {
      final m = ChatMetricsModel.fromJson({
        'cultural_coverage': {
          'percent': 72.5,
          'matched_terms': ['yaz', 'tifinagh'],
        },
        'distinct_1': 0.81,
        'distinct_2': 0.64,
      });
      expect(m.culturalCoveragePercent, 72.5);
      expect(m.distinct1, 0.81);
      expect(m.distinct2, 0.64);
      expect(m.matchedTerms, ['yaz', 'tifinagh']);
    });

    test('tolerates missing fields', () {
      final m = ChatMetricsModel.fromJson(const {});
      expect(m.culturalCoveragePercent, 0);
      expect(m.matchedTerms, isEmpty);
    });
  });

  group('DocCategory mapping', () {
    test('round-trips the corpus token', () {
      expect(DocCategoryX.fromApi('savoir-faire'), DocCategory.savoirFaire);
      expect(DocCategory.savoirFaire.apiValue, 'savoir-faire');
      expect(DocCategoryX.fromApi('bijou'), DocCategory.bijou);
    });
  });

  group('AppValidators', () {
    test('email', () {
      expect(AppValidators.validateEmail('a@b.com'), isNull);
      expect(AppValidators.validateEmail('nope'), isNotNull);
    });

    test('password requires length + letters + digits', () {
      expect(AppValidators.validatePassword('abc12345'), isNull);
      expect(AppValidators.validatePassword('short'), isNotNull);
    });
  });
}
