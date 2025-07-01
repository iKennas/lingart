
// screens/modules/chat_screen.dart
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> messages = [
    ChatMessage(
      id: '1',
      senderId: 'teacher',
      senderName: 'Öğretmen',
      message: 'Merhaba! Size nasıl yardımcı olabilirim?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isFromTeacher: true,
    ),
    ChatMessage(
      id: '2',
      senderId: 'student1',
      senderName: 'Ahmet',
      message: 'Dilbilgisi konusunda sorum var.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ];

  bool isPremiumUser = false; // This would be determined by user's subscription

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.chat),
        backgroundColor: AppColors.chatModule,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              // Show chat rules or help
            },
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppConstants.mediumPadding),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),

          // Premium notice for teacher questions
          if (!isPremiumUser)
            Container(
              padding: EdgeInsets.all(AppConstants.mediumPadding),
              color: AppColors.warning.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.star, color: AppColors.warning),
                  SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Text(
                      'Öğretmene soru sormak için premium üyelik gerekli',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to premium subscription
                    },
                    child: const Text('Premium Al'),
                  ),
                ],
              ),
            ),

          // Message input
          Container(
            padding: EdgeInsets.all(AppConstants.mediumPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.chatModule,
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                SizedBox(width: AppConstants.mediumPadding),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppConstants.mediumPadding,
                        vertical: AppConstants.smallPadding,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: AppConstants.smallPadding),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send, color: AppColors.chatModule),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.chatModule.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isCurrentUser = message.senderId != 'teacher';

    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.mediumPadding),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: message.isFromTeacher ? AppColors.success : AppColors.primary,
              child: Icon(
                message.isFromTeacher ? Icons.school : Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(width: AppConstants.smallPadding),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: EdgeInsets.all(AppConstants.mediumPadding),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppColors.chatModule
                  : (message.isFromTeacher ? AppColors.success : AppColors.accent),
              borderRadius: BorderRadius.circular(AppConstants.largeRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser)
                  Text(
                    message.senderName,
                    style: AppTextStyles.caption.copyWith(
                      color: message.isFromTeacher ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  message.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isCurrentUser || message.isFromTeacher ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppConstants.smallPadding),
                Text(
                  Helpers.formatTimeAgo(message.timestamp),
                  style: AppTextStyles.caption.copyWith(
                    color: (isCurrentUser || message.isFromTeacher)
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentUser) ...[
            SizedBox(width: AppConstants.smallPadding),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      senderName: 'Sen',
      message: _messageController.text.trim(),
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.add(newMessage);
      _messageController.clear();
    });
  }
}
