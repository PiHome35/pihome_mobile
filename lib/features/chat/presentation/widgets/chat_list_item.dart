import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/chat/domain/entities/chat.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_event.dart';

class ChatListItem extends StatelessWidget {
  final ChatEntity chat;
  final ChatBloc chatBloc;
  final Function() onChatDeleted;
  const ChatListItem({
    super.key,
    required this.chat,
    required this.chatBloc,
    required this.onChatDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSpeakerChat = chat.deviceId != null;
    log('chat: ${chat.deviceId}');
    log('chat lasted Message: ${chat.latestMessage}');

    return Card(
      elevation: 0,
      color: isSpeakerChat
          ? theme.colorScheme.primary.withOpacity(0.05)
          : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: isSpeakerChat
            ? BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.1),
                width: 1.w,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () async {
          final isDeleteChat = await AppRoutes.navigateToChatRoom(
            context,
            chat.id,
            chat.deviceId,
            chat.name,
            chat.familyId,
          );
          if (isDeleteChat) {
            log('isDeleteChat: $isDeleteChat');
            // chatBloc.add(DeleteChat(chatId: chat.id));
            // context.read<ChatBloc>().add(DeleteChat(chatId: chat.id));
            // chatBloc.add(GetAllChats(
            //   familyId: chat.familyId,
            //   limit: 20,
            // ));
            // chatBloc.add(DeleteChat(chatId: chat.id));
            onChatDeleted();
          }
        },
        child: Container(
          height: 90.h,
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(context),
              SizedBox(width: 16.w),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                chat.name,
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (chat.latestMessage != null) ...[
                              SizedBox(width: 8.w),
                              Text(
                                _formatDate(chat.latestMessage!.createdAt),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Flexible(
                          child: Text(
                            chat.latestMessage?.content ?? 'No messages yet',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 13.sp,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);
    final firstLetter = chat.name[0].toUpperCase();
    final isSpeakerChat = chat.deviceId != null;

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSpeakerChat
            ? theme.colorScheme.primary
            : theme.colorScheme.primaryContainer,
        border: isSpeakerChat
            ? Border.all(
                color: theme.colorScheme.primaryContainer,
                width: 2.w,
              )
            : null,
      ),
      child: Center(
        child: isSpeakerChat
            ? Icon(
                Icons.speaker_rounded,
                color: theme.colorScheme.onPrimary,
                size: 24.sp,
              )
            : Text(
                firstLetter,
                style: AppTextStyles.headingSmall.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontSize: 20.sp,
                ),
              ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now().toLocal();
    final localDate = date.toLocal();
    final difference = now.difference(localDate);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays == 0) {
      return '${localDate.hour}:${localDate.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${localDate.day}/${localDate.month}';
    }
  }
}
