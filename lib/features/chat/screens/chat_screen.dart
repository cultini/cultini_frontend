import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/azetta_motif.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/feature_ui_config.dart';
import '../../../core/extensions/snackbar_extensions.dart';
import '../../../di/injection_container.dart';
import '../presentation/bloc/chat_bloc.dart';
import '../presentation/bloc/chat_event.dart';
import '../presentation/bloc/chat_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/suggestion_chips_row.dart';

/// ─── AI Chat Screen ───────────────────────────────────────────────────────────
/// Talks to the FastAPI `/chat` endpoint via [ChatBloc]; renders the answer
/// with its sources + anti-lissage metrics.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (_) => sl<ChatBloc>()..add(const ChatStarted()),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _scrollCtrl = ScrollController();
  final _inputCtrl = TextEditingController();
  final _focusNode = FocusNode();

  static const _suggestions = FeatureUiConfig.chatSuggestions;

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _inputCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    _inputCtrl.clear();
    context.read<ChatBloc>().add(ChatMessageSent(text));
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              AppStrings.chatTitle,
              style: GoogleFonts.fraunces(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Assistant culturel amazigh',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (prev, curr) =>
            prev.error != curr.error || prev.messages.length != curr.messages.length,
        listener: (context, state) {
          if (state.error != null) {
            context.showErrorSnackBar(state.error!);
          }
          _scrollToBottom();
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  color: AppColors.surfaceVariant,
                  child: AzettaBackground(
                    child: state.messages.isEmpty && !state.isLoading
                      ? const _EmptyState()
                      : ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            // The streaming AI placeholder is empty until the
                            // first token lands — show the typing indicator in
                            // its place rather than an empty bubble.
                            if (!message.isUser &&
                                message.text.isEmpty &&
                                state.isLoading) {
                              return const _TypingIndicator();
                            }
                            return MessageBubble(message: message);
                          },
                        ),
                  ),
                ),
              ),
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SuggestionChipsRow(
                  suggestions: _suggestions,
                  onSelected: _send,
                ),
              ),
              _InputBar(
                controller: _inputCtrl,
                focusNode: _focusNode,
                onSend: _send,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 40, color: AppColors.indigo),
            const SizedBox(height: 12),
            Text(
              AppStrings.chatWelcome,
              textAlign: TextAlign.center,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.indigo,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.auto_awesome,
                size: 16, color: AppColors.accent),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.chatBubbleAI,
              border: Border.all(color: AppColors.divider),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: onSend,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.chatPlaceholder,
                  hintStyle: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onSend(controller.text),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: AppColors.textLight,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
