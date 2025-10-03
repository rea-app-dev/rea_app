import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/conversation.dart';
import '../../data/services/chat_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/hamburger_menu.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({Key? key}) : super(key: key);

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  List<Conversation> _conversations = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    final currentUser = context.read<AuthProvider>().currentUser!;
    final conversations = await ChatService.getUserConversations(currentUser.id);

    if (mounted) {
      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
    }
  }

  List<Conversation> get _filteredConversations {
    if (_searchQuery.isEmpty) return _conversations;

    return _conversations.where((conversation) {
      final currentUser = context.read<AuthProvider>().currentUser!;
      final otherParticipant = conversation.participantsInfo.firstWhere(
            (p) => p.id != currentUser.id,
      );

      return otherParticipant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          conversation.propertyTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          conversation.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const HamburgerMenu(),
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _buildConversationsList(l10n, isDark),
          ),
        ],
      ),
      floatingActionButton: _buildNewMessageFAB(l10n),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, bool isDark) {
    final unreadCount = _conversations.fold<int>(0, (sum, conv) => sum + conv.unreadCount);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.messagingTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.blue,
                ),
              ),
              if (unreadCount > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '${unreadCount} ${l10n.unreadMessages}',
                  style: const TextStyle(
                    color: AppColors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const Spacer(),

          // Badge avec nombre de conversations
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_conversations.length}',
              style: const TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: l10n.searchInConversations,
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: AppColors.grey),
            onPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildConversationsList(AppLocalizations l10n, bool isDark) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.orange),
      );
    }

    final filteredConversations = _filteredConversations;

    if (filteredConversations.isEmpty) {
      return _buildEmptyState(l10n);
    }

    return RefreshIndicator(
      onRefresh: _loadConversations,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filteredConversations.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return _buildConversationTile(filteredConversations[index], l10n, isDark);
        },
      ),
    );
  }

  Widget _buildConversationTile(Conversation conversation, AppLocalizations l10n, bool isDark) {
    final currentUser = context.read<AuthProvider>().currentUser!;
    final otherParticipant = conversation.participantsInfo.firstWhere(
          (p) => p.id != currentUser.id,
    );

    final isUnread = conversation.unreadCount > 0;
    final timeDiff = DateTime.now().difference(conversation.lastMessageTime);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.blue.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isUnread
            ? Border.all(color: AppColors.blue.withOpacity(0.2))
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.lightGrey,
              child: Text(
                otherParticipant.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (otherParticipant.isVerified)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                otherParticipant.name,
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              conversation.propertyTitle,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getTimeText(timeDiff),
              style: TextStyle(
                color: isUnread ? AppColors.orange : AppColors.grey,
                fontSize: 12,
                fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
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
                  conversation.unreadCount > 99 ? '99+' : conversation.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        onTap: () => AppRoutes.goToChat(context, conversation),
        onLongPress: () => _showConversationOptions(context, conversation, l10n),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: AppColors.blue.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
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
            style: const TextStyle(
              color: AppColors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Retourner à l'accueil pour chercher des biens
              AppRoutes.pushNamed(context, AppRoutes.home);
            },
            icon: const Icon(Icons.search, color: Colors.white),
            label: Text(l10n.findProperties),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewMessageFAB(AppLocalizations l10n) {
    return FloatingActionButton(
      onPressed: () => _showComingSoonDialog(context, l10n, l10n.newMessage),
      backgroundColor: AppColors.orange,
      child: const Icon(Icons.add_comment, color: Colors.white),
    );
  }

  // Helper methods
  String _getTimeText(Duration diff) {
    if (diff.inMinutes < 1) return AppLocalizations.of(context)!.now;
    if (diff.inHours < 1) return AppLocalizations.of(context)!.minutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return AppLocalizations.of(context)!.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return AppLocalizations.of(context)!.daysAgo(diff.inDays);
    return AppLocalizations.of(context)!.weeksAgo(diff.inDays ~/ 7);
  }

  void _showConversationOptions(BuildContext context, Conversation conversation, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              l10n.conversationOptions,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.mark_chat_read, color: AppColors.blue),
              title: Text(l10n.markAsRead),
              onTap: () {
                Navigator.pop(context);
                // TODO: Marquer comme lu
              },
            ),

            ListTile(
              leading: const Icon(Icons.push_pin, color: AppColors.orange),
              title: Text(l10n.pinConversation),
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, l10n, l10n.pinConversation);
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: Text(l10n.deleteConversation),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmDialog(context, conversation, l10n);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, Conversation conversation, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConversation),
        content: Text(l10n.deleteConversationConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, AppLocalizations l10n, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.construction, color: AppColors.orange),
            const SizedBox(width: 8),
            Text(l10n.comingSoon),
          ],
        ),
        content: Text(l10n.comingSoonMessage(feature)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}