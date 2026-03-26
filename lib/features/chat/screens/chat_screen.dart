import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outty/app.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/enums/message_type.dart';
import 'package:outty/features/chat/models/chat_message.dart';
import 'package:outty/features/chat/models/chat_room.dart';
import 'package:outty/features/chat/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;
  const ChatScreen({super.key, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isComposing = false;
  bool _isReplying = false;
  bool _showEmojiPicker = false;
  FocusNode _messageFocusNode = FocusNode();
  Map<String, VideoPlayerController> _videoControllers = {};
  ChatMessage? _replyToMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(
        context,
        listen: false,
      ).loadMessages(widget.chatRoom.id);
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.getMessagesForChatRoom(widget.chatRoom.id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.backgroundDark
          : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDarkMode ? Colors.white : Colors.grey.shade800,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Image.asset(
                      widget.chatRoom.matchImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (widget.chatRoom.isMatchOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.grey.shade900
                              : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatRoom.matchName,
                  style: TextStyle(
                    color: isDarkMode
                        ? Colors.white
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.chatRoom.isMatchOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: widget.chatRoom.isMatchOnline
                        ? Colors.green
                        : (isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: isDarkMode ? Colors.white : Colors.grey.shade800,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: isDarkMode
                              ? Colors.grey.shade700
                              : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Say hi to ${widget.chatRoom.matchName}!',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe =
                          message.senderId == chatProvider.currentUserId;
                      final showDate =
                          index == 0 ||
                          !_isSameDay(
                            messages[index - 1].timestamp,
                            message.timestamp,
                          );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (showDate)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _formatMessageDate(message.timestamp),
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.grey.shade300
                                          : Colors.grey.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          _buildMessageItem(message, isMe, isDarkMode),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message, bool isMe, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _buildAvatar(isDarkMode),
          const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onLongPress: () {},
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (message.replyToId != null)
                    _buildReplyContent(message, isMe, isDarkMode),

                  if (message.messageType == MessageType.text)
                    _buildTextMessage(message, isMe, isDarkMode),

                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: isMe
                        ? _buildMessageStatus(message, isDarkMode)
                        : Text(
                            DateFormat('h:mm a').format(message.timestamp),
                            style: TextStyle(
                              fontSize: 10,
                              color: isDarkMode
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade600,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildMessageStatus(ChatMessage message, bool isDarkMode) {
    final Color statusColor = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          message.isRead ? Icons.done_all : Icons.done,
          size: 16,
          color: statusColor,
        ),
        const SizedBox(width: 4),
        Text(
          DateFormat('h:mm a').format(message.timestamp),
          style: TextStyle(fontSize: 10, color: statusColor),
        ),
      ],
    );
  }

  Widget _buildTextMessage(ChatMessage message, bool isMe, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.primary
            : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(18).copyWith(
          bottomRight: isMe ? Radius.circular(0) : null,
          bottomLeft: isMe ? Radius.circular(0) : null,
        ),
      ),
      child: Text(
        message.content,
        style: TextStyle(
          color: isMe
              ? Colors.white
              : (isDarkMode ? Colors.white : Colors.black),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildReplyContent(ChatMessage message, bool isMe, bool isDarkMode) {
    if (message.replyToId == null) return SizedBox.shrink();

    final isReplyToMe =
        message.replyToSenderId ==
        Provider.of<ChatProvider>(context, listen: false).currentUserId;

    return GestureDetector(
      onTap: () {},

      child: Container(
        margin: EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey.shade800.withValues(alpha: 0.5)
              : Colors.grey.shade200.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: AppColors.primary, width: 2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.replay,
                  size: 14,
                  color: isReplyToMe
                      ? AppColors.primary
                      : (isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                ),

                const SizedBox(width: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isDarkMode) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 32,
        height: 32,
        child: Image.asset(widget.chatRoom.matchImage, fit: BoxFit.cover),
      ),
    );
  }

  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
