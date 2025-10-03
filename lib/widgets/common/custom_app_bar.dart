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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? AppColors.darkGrey : AppColors.white,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            // Logo REA avec icône maison
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: isDark ? AppColors.white : AppColors.blue,
                    size: 35,
                  ),
                  onPressed: () {
                    if (scaffoldKey?.currentState != null) {
                      scaffoldKey!.currentState!.openDrawer();
                    } else {
                      Scaffold.of(context).openDrawer();
                    }
                  },
                ),
                Text(
                  'REA',
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Badge Reacoins/Solde
            if (currentUser != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkGrey.withOpacity(0.5) : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppColors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_circle,
                      size: 20,
                      color: isDark ? AppColors.white : AppColors.blue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      currentUser.userType.name == 'proprietaire'
                          ? '10 000 FCFA'
                          : '33 REA coins',
                      style: TextStyle(
                        color: isDark ? AppColors.white : AppColors.blue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(width: 12),

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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkGrey : AppColors.lightGrey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.grey.withOpacity(0.3),
                    width: 2,
                  ),
                  image: currentUser?.profilePicture != null
                      ? DecorationImage(
                    image: NetworkImage(currentUser!.profilePicture!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: currentUser?.profilePicture == null
                    ? Icon(
                  Icons.person,
                  color: isDark ? AppColors.white : AppColors.blue,
                  size: 24,
                )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}