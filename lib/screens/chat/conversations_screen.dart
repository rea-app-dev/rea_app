// lib/screens/chat/conversations_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reaapp/widgets/common/custom_app_bar.dart';
import 'package:reaapp/widgets/common/hamburger_menu.dart';
import '../../core/constants/colors.dart';
import '../../data/models/conversation.dart';
import '../../data/services/chat_service.dart';
import '../../providers/auth_provider.dart';
import 'chat_screen.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({Key? key}) : super(key: key);

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  List<Conversation> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final currentUser = context.read<AuthProvider>().currentUser!;
    final conversations = await ChatService.getUserConversations(currentUser.id);
    setState(() {
      _conversations = conversations;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const HamburgerMenu(),
      appBar: const CustomAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
          ? _buildEmptyState(l10n)
          : RefreshIndicator(
        onRefresh: _loadConversations,
        child: ListView.builder(
          itemCount: _conversations.length,
          itemBuilder: (context, index) {
            return _buildConversationTile(_conversations[index]);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppColors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.noConversations,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noConversationsMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(Conversation conversation) {
    final currentUser = context.read<AuthProvider>().currentUser!;
    final otherParticipant = conversation.participantsInfo.firstWhere(
          (p) => p.id != currentUser.id,
    );

    final isUnread = conversation.unreadCount > 0;
    final timeDiff = DateTime.now().difference(conversation.lastMessageTime);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openConversation(conversation),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.lightGrey,
                  child: Text(
                    otherParticipant.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Contenu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom + badge accord
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              otherParticipant.name,
                              style: TextStyle(
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.white
                                    : AppColors.blue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (conversation.isAccordTrouve)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.check_circle, size: 12, color: AppColors.green),
                                  SizedBox(width: 4),
                                  Text(
                                    'Accord',
                                    style: TextStyle(
                                      color: AppColors.green,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Titre propriété
                      Text(
                        conversation.propertyTitle,
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      // Dernier message
                      Text(
                        conversation.lastMessage,
                        style: TextStyle(
                          color: isUnread ? AppColors.blue : AppColors.grey,
                          fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Heure + badge non lu
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getTimeText(timeDiff),
                      style: TextStyle(
                        color: isUnread ? AppColors.orange : AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isUnread)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          conversation.unreadCount.toString(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeText(Duration diff) {
    if (diff.inMinutes < 1) return "Maintenant";
    if (diff.inHours < 1) return "${diff.inMinutes}min";
    if (diff.inDays < 1) return "${diff.inHours}h";
    if (diff.inDays < 7) return "${diff.inDays}j";
    return "${diff.inDays ~/ 7}sem";
  }

  void _openConversation(Conversation conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(conversation: conversation),
      ),
    );
  }
}