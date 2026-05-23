import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized backend configuration.
///
/// Cultini talks to TWO backends:
///   • Auth   — Node/Express  (default :3000)  → [authBaseUrl]
///   • AI/RAG — FastAPI Azetta (default :8000)  → [aiBaseUrl]
///
/// Override either via `.env` (`AUTH_BASE_URL`, `AI_BASE_URL`). The defaults use
/// `10.0.2.2`, which is the host machine's loopback as seen from the Android
/// emulator (use `localhost` for iOS simulator / desktop, or a LAN IP for a
/// physical device).
class EndPoints {
  EndPoints._();

  static String _env(String key, String fallback) {
    final value = dotenv.env[key]?.trim();
    return (value == null || value.isEmpty) ? fallback : value;
  }

  /// Node/Express auth backend.
  static String get authBaseUrl => _env('AUTH_BASE_URL', 'http://10.0.2.2:3000');

  /// FastAPI Azetta RAG backend.
  static String get aiBaseUrl => _env('AI_BASE_URL', 'http://10.0.2.2:8000');

  // ── Auth (Node/Express) ─────────────────────────────────────────────────────
  static const String authLogin = '/api/auth/login';
  static const String authRegister = '/api/auth/register';

  // ── AI / RAG (FastAPI) ──────────────────────────────────────────────────────
  /// Routed, context-aware chat with per-`chat_id` memory.
  static const String chat = '/chat';

  /// Submit a contribution → auto-filter + moderation queue.
  static const String contributions = '/contributions';
}
