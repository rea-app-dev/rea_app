// lib/screens/notifications/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:reaapp/widgets/common/custom_app_bar.dart';
import 'package:reaapp/widgets/common/hamburger_menu.dart';
import '../../core/constants/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'Nouvel appartement disponible',
      'message': 'Un appartement 2 pièces à Douala Akwa correspond à vos critères.',
      'time': '13:20',
      'isRead': false,
    },
    {
      'title': 'Vues sur votre annonce',
      'message': 'Votre annonce a reçu 5 nouvelles vues aujourd\'hui.',
      'time': '09:45',
      'isRead': false,
    },
    {
      'title': 'Nouveau message',
      'message': 'Paul BIYA vous a envoyé un message.',
      'time': '08:15',
      'isRead': true,
    },
    {
      'title': 'Accord trouvé',
      'message': 'Accord trouvé pour votre maison à Omnisport.',
      'time': 'Hier 14:30',
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HamburgerMenu(),
      appBar: const CustomAppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return _buildNotificationItem(notif, index);
        },
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notif, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notif['isRead'] ? Colors.white : AppColors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: ListTile(
        leading: Icon(
          Icons.notifications,
          color: notif['isRead'] ? AppColors.grey : AppColors.orange,
        ),
        title: Text(
          notif['title'],
          style: TextStyle(
            fontWeight: notif['isRead'] ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notif['message']),
            const SizedBox(height: 4),
            Text(
              notif['time'],
              style: TextStyle(color: AppColors.grey, fontSize: 12),
            ),
          ],
        ),
        trailing: notif['isRead']
            ? null
            : Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.orange,
            shape: BoxShape.circle,
          ),
        ),
        onTap: () => _showNotificationDialog(notif, index),
      ),
    );
  }

  void _showNotificationDialog(Map<String, dynamic> notif, int index) {
    // Marquer comme lu
    if (!notif['isRead']) {
      setState(() {
        notifications[index]['isRead'] = true;
      });
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notif['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notif['message']),
            const SizedBox(height: 8),
            Text(
              notif['time'],
              style: TextStyle(color: AppColors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}