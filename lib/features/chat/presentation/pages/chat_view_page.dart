import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/theme/chat_message_typography.dart';
import 'package:myitihas/features/chat/presentation/bloc/chat_detail_bloc.dart';
import 'package:myitihas/features/chat/presentation/bloc/chat_detail_event.dart';
import 'package:myitihas/features/chat/presentation/bloc/chat_detail_state.dart';
import 'package:myitihas/features/chat/presentation/widgets/shared_content_preview_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatViewPage extends StatelessWidget {
  const ChatViewPage({super.key, required this.conversationId});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return BlocProvider(
      create: (_) =>
          getIt<ChatDetailBloc>()..add(LoadMessagesEvent(conversationId)),
      child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
        builder: (context, state) {
          if (state is ChatDetailLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController.jumpTo(
                  scrollController.position.maxScrollExtent,
                );
              }
            });
            return ListView.builder(
              controller: scrollController,
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                // If message is a shared post/story, show preview
                if (message.sharedContentId != null &&
                    message.sharedContentId!.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: SharedContentPreviewWidget(
                      sharedContentId: message.sharedContentId!,
                      contentType: message.type,
                    ),
                  );
                }
                final scheme = Theme.of(context).colorScheme;
                final uid = Supabase.instance.client.auth.currentUser?.id;
                final isMe = uid != null && uid == message.senderId;
                final fg = isMe
                    ? ChatMessageTypography.outgoingMessageForeground(scheme)
                    : ChatMessageTypography.incomingMessageForeground(scheme);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: isMe
                            ? scheme.primaryContainer.withValues(alpha: 0.42)
                            : scheme.surfaceContainerHigh.withValues(
                                alpha: 0.85,
                              ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Text(
                          message.text,
                          style: ChatMessageTypography.bodyStyle(color: fg),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is ChatDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatDetailError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
