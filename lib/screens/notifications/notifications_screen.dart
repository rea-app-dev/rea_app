import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/hamburger_menu.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    await Future.delayed(const Duration(milliseconds: 800));

    _notifications = [
      AppNotification(
        id: '1',
        type: NotificationType.message,
        title: 'Nouveau message',
        message: 'Paul BIYA vous a envoyé un message concernant l\'appartement à Bonanjo',
        time: DateTime.now().subtract(const Duration(minutes: 10)),
        isRead: false,
        priority: NotificationPriority.high,
        actionable: true,
      ),
      AppNotification(
        id: '2',
        type: NotificationType.agreement,
        title: 'Accord conclu !',
        message: 'Félicitations ! Votre location avec Jeanne IRÈNE est confirmée',
        time: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        priority: NotificationPriority.high,
        actionable: true,
      ),
      AppNotification(
        id: '3',
        type: NotificationType.propertyAlert,
        title: 'Nouveau bien disponible',
        message: 'Un appartement 3 pièces à Yaoundé Melen correspond à vos critères',
        time: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
        priority: NotificationPriority.medium,
        actionable: true,
      ),
      AppNotification(
        id: '4',
        type: NotificationType.activity,
        title: 'Votre annonce est populaire',
        message: 'Votre studio à Bastos a reçu 15 nouvelles vues aujourd\'hui',
        time: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: true,
        priority: NotificationPriority.low,
        actionable: false,
      ),
      AppNotification(
        id: '5',
        type: NotificationType.system,
        title: 'Mise à jour disponible',
        message: 'REA v1.2.0 est disponible avec de nouvelles fonctionnalités',
        time: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
        priority: NotificationPriority.medium,
        actionable: true,
      ),
      AppNotification(
        id: '6',
        type: NotificationType.payment,
        title: 'Paiement reçu',
        message: 'Le loyer de septembre a été reçu avec succès',
        time: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        priority: NotificationPriority.medium,
        actionable: false,
      ),
    ];

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  List<AppNotification> get _filteredNotifications {
    final currentIndex = _tabController.index;
    switch (currentIndex) {
      case 0: // Toutes
        return _notifications;
      case 1: // Non lues
        return _notifications.where((n) => !n.isRead).toList();
      case 2: // Importantes
        return _notifications.where((n) => n.priority == NotificationPriority.high).toList();
      case 3: // Actions
        return _notifications.where((n) => n.actionable).toList();
      default:
        return _notifications;
    }
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
            child: TabBarView(
              controller: _tabController,
              children: List.generate(4, (index) => _buildNotificationsList(l10n, isDark)),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildNotificationsList(AppLocalizations l10n, bool isDark) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.orange),
            SizedBox(height: 16),
            Text(
              'Chargement des notifications...',
              style: TextStyle(color: AppColors.grey),
            ),
          ],
        ),
      );
    }

    final filteredNotifications = _filteredNotifications;

    if (filteredNotifications.isEmpty) {
      return _buildEmptyState(l10n);
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: filteredNotifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final notification = filteredNotifications[index];
          return _buildNotificationCard(notification, l10n, isDark);
        },
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification, AppLocalizations l10n, bool isDark) {
    final typeConfig = _getNotificationConfig(notification.type);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: !notification.isRead
            ? Border.all(color: AppColors.orange.withOpacity(0.3), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: !notification.isRead
                ? AppColors.orange.withOpacity(0.1)
                : (isDark ? Colors.black : Colors.grey).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleNotificationTap(notification, l10n),
          onLongPress: () => _showNotificationMenu(notification, l10n),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icône avec badge de priorité
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // Contenu principal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                                    color: isDark ? AppColors.white : Colors.black87,
                                  ),
                                ),
                              ),
                              Text(
                                _formatTime(notification.time),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: !notification.isRead ? AppColors.orange : AppColors.grey,
                                  fontWeight: !notification.isRead ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notification.message,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Indicateur non lu
                    if (!notification.isRead) ...[
                      const SizedBox(width: 12),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontSize: 12),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 32),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    final currentTab = _tabController.index;
    String title, subtitle;
    IconData icon;

    switch (currentTab) {
      case 1: // Non lues
        title = 'Aucune notification non lue';
        subtitle = 'Toutes vos notifications ont été consultées !';
        icon = Icons.mark_email_read;
        break;
      case 2: // Importantes
        title = 'Aucune notification importante';
        subtitle = 'Vous n\'avez pas de notifications prioritaires.';
        icon = Icons.priority_high;
        break;
      case 3: // Actions
        title = 'Aucune action requise';
        subtitle = 'Aucune notification ne nécessite votre attention.';
        icon = Icons.check_circle;
        break;
      default:
        title = 'Aucune notification';
        subtitle = 'Vous n\'avez pas encore reçu de notifications.';
        icon = Icons.notifications_none;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  NotificationConfig _getNotificationConfig(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return NotificationConfig(Icons.message, AppColors.blue);
      case NotificationType.agreement:
        return NotificationConfig(Icons.handshake, AppColors.green);
      case NotificationType.propertyAlert:
        return NotificationConfig(Icons.home_outlined, AppColors.orange);
      case NotificationType.activity:
        return NotificationConfig(Icons.trending_up, AppColors.blue);
      case NotificationType.payment:
        return NotificationConfig(Icons.payment, AppColors.green);
      case NotificationType.system:
        return NotificationConfig(Icons.system_update, AppColors.grey);
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'Maintenant';
    if (difference.inHours < 1) return '${difference.inMinutes}min';
    if (difference.inDays < 1) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}j';
    return '${difference.inDays ~/ 7}sem';
  }

  void _handleNotificationTap(AppNotification notification, AppLocalizations l10n) {
    if (!notification.isRead) {
      setState(() {
        notification.isRead = true;
      });
    }
  }

  void _handleAction(String action, AppNotification notification) {
    // Simuler différentes actions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action "$action" pour ${notification.title}'),
        backgroundColor: AppColors.blue,
      ),
    );
  }

  void _showNotificationMenu(AppNotification notification, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 24),

            ListTile(
              leading: Icon(
                notification.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
                color: AppColors.blue,
              ),
              title: Text(notification.isRead ? 'Marquer comme non lu' : 'Marquer comme lu'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  notification.isRead = !notification.isRead;
                });
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Supprimer'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _notifications.remove(notification);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }
}

// Data models
class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime time;
  bool isRead;
  final NotificationPriority priority;
  final bool actionable;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.priority,
    required this.actionable,
  });
}

enum NotificationType {
  message,
  agreement,
  propertyAlert,
  activity,
  payment,
  system,
}

enum NotificationPriority {
  low,
  medium,
  high,
}

class NotificationConfig {
  final IconData icon;
  final Color color;

  NotificationConfig(this.icon, this.color);
}