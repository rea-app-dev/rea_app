// lib/widgets/common/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../screens/profile/profile_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomAppBar({
    Key? key,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthProvider>().currentUser;

    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: AppColors.blue,
        ),
        onPressed: () {
          if (scaffoldKey?.currentState != null) {
            scaffoldKey!.currentState!.openDrawer();
          } else {
            Scaffold.of(context).openDrawer();
          }
        },
      ),
      title: Row(
        children: [
          Text(
            'REA',
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Solde utilisateur
          if (currentUser != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    currentUser.userType.name == 'proprietaire'
                        ? Icons.account_balance_wallet
                        : Icons.monetization_on,
                    size: 16,
                    color: AppColors.blue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    currentUser.userType.name == 'proprietaire'
                        ? "1000 FCFA"//'${_formatBalance(currentUser.balance)} FCFA'
                        : "100 coins",//'${currentUser.coins} coins',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        // Photo de profil
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.lightGrey,
              backgroundImage: currentUser?.profilePicture != null
                  ? NetworkImage(currentUser!.profilePicture!)
                  : null,
              child: currentUser?.profilePicture == null
                  ? Text(
                currentUser?.firstName.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  String _formatBalance(double balance) {
    if (balance >= 1000000) {
      return '${(balance / 1000000).toStringAsFixed(1)}M';
    } else if (balance >= 1000) {
      return '${(balance / 1000).toStringAsFixed(1)}K';
    } else {
      return balance.toInt().toString();
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}