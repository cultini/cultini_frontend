import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/app_local_storage.dart';
import '../models/contribution_model.dart';

abstract class ContributionLocalDataSource {
  Future<void> save(ContributionModel contribution);
  Future<List<ContributionModel>> getAll();
}

/// Mock store: appends submissions to shared_preferences and logs them. Replace
/// with a remote data source (POST) when the backend exposes an endpoint.
class ContributionLocalDataSourceImpl implements ContributionLocalDataSource {
  ContributionLocalDataSourceImpl(this.storage);
  final AppLocalStorage storage;

  @override
  Future<void> save(ContributionModel contribution) async {
    final existing = await getAll();
    final updated = [...existing, contribution];
    await storage.setString(
      StorageKeys.contributions,
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
    debugPrint('[Contribution submitted] ${jsonEncode(contribution.toJson())}');
  }

  @override
  Future<List<ContributionModel>> getAll() async {
    final raw = storage.getString(StorageKeys.contributions);
    if (raw == null || raw.isEmpty) return <ContributionModel>[];
    final decoded = (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    return decoded.map(ContributionModel.fromJson).toList();
  }
}
