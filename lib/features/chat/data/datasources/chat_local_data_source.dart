import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/app_local_storage.dart';
import '../models/chat_message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<ChatMessageModel>> getCachedHistory();
  Future<void> cacheHistory(List<ChatMessageModel> messages);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  ChatLocalDataSourceImpl({required this.storage});
  final AppLocalStorage storage;

  @override
  Future<void> cacheHistory(List<ChatMessageModel> messages) async {
    final payload = jsonEncode(messages.map((e) => e.toJson()).toList());
    await storage.setString(StorageKeys.chatHistory, payload);
  }

  @override
  Future<List<ChatMessageModel>> getCachedHistory() async {
    final raw = storage.getString(StorageKeys.chatHistory);
    if (raw == null || raw.isEmpty) {
      return <ChatMessageModel>[];
    }
    final decoded = (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    return decoded.map(ChatMessageModel.fromJson).toList();
  }
}
