import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/property.dart';
import '../../data/services/chat_service.dart';
import '../../providers/auth_provider.dart';

class PropertyCard extends StatefulWidget {
  final Property property;

  const PropertyCard({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool _isFavorite = false;
  bool _isContacting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zone photo avec badges
          _buildImageSection(l10n),

          // Contenu
          _buildContentSection(l10n, isDark),

          // Actions
          _buildActionsSection(l10n),
        ],
      ),
    );
  }

  Widget _buildImageSection(AppLocalizations l10n) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          // Placeholder photos avec dégradé
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.lightGrey,
                  AppColors.lightGrey.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera_outlined, size: 24, color: AppColors.grey),
                  const SizedBox(height: 4),
                  Text(
                    l10n.photosVideos,
                    style: TextStyle(color: AppColors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),

          // Badges du haut
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Row(
              children: [
                const Spacer(),
                // Badges droite (vues + favori)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isFavorite = !_isFavorite),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 12,
                          color: _isFavorite ? AppColors.error : AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Badge disponible (bas gauche)
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: widget.property.isAvailable ? AppColors.green : AppColors.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.property.isAvailable ? l10n.available : l10n.rented,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Rating (bas droite)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 10, color: AppColors.orange),
                  const SizedBox(width: 2),
                  Text(
                    widget.property.rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(AppLocalizations l10n, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Text(
            widget.property.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Localisation
          Row(
            children: [
              Icon(Icons.location_on, size: 12, color: AppColors.grey),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  widget.property.quartier,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Détails rapides
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.property.standingText.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.orange,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          // Prix
          Text(
            widget.property.formattedPrice,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => AppRoutes.goToPropertyDetail(context, widget.property),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.orange, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                minimumSize: const Size(0, 32),
              ),
              child: Text(
                l10n.propertyDetails,
                style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Bouton message
          Container(
            width: 32,
            height: 32,
            child: OutlinedButton(
              onPressed: _isContacting ? null : () => _contactOwner(context, l10n),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: _isContacting ? AppColors.grey : AppColors.blue,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.zero,
              ),
              child: _isContacting
                  ? SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.grey,
                ),
              )
                  : const Icon(
                Icons.chat_bubble_outline,
                size: 14,
                color: AppColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _contactOwner(BuildContext context, AppLocalizations l10n) async {
    if (_isContacting) return;

    setState(() => _isContacting = true);

    try {
      final currentUser = context.read<AuthProvider>().currentUser!;

      final conversationId = await ChatService.createConversation(
        senderId: currentUser.id,
        receiverId: widget.property.ownerId,
        propertyId: widget.property.id,
        propertyTitle: widget.property.title,
        initialMessage: l10n.propertyContactMessage(widget.property.title),
      );

      if (conversationId != null && context.mounted) {
        final conversation = await ChatService.getConversation(conversationId);
        if (conversation != null) {
          AppRoutes.goToChat(context, conversation);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorOpeningChat),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isContacting = false);
      }
    }
  }
}