import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/colors.dart';

enum EmptyStateType {
  noResults,
  noProperties,
  noConversations,
  noNotifications,
  noFavorites,
  networkError,
  serverError,
  generic,
}

class EmptyStateWidget extends StatelessWidget {
  final EmptyStateType type;
  final String? title;
  final String? description;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Widget? customWidget;
  final bool showAction;

  const EmptyStateWidget({
    Key? key,
    required this.type,
    this.title,
    this.description,
    this.icon,
    this.actionText,
    this.onActionPressed,
    this.customWidget,
    this.showAction = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom widget or icon
            if (customWidget != null)
              customWidget!
            else
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkGrey : AppColors.lightGrey).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIcon(context),
                  size: 64,
                  color: _getIconColor(isDark),
                ),
              ),

            const SizedBox(height: 24),

            // Title
            Text(
              title ?? _getTitle(l10n),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              description ?? _getDescription(l10n),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action button
            if (showAction && _hasAction()) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onActionPressed ?? () => _getDefaultAction(context),
                  icon: Icon(_getActionIcon()),
                  label: Text(actionText ?? _getActionText(l10n)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getActionColor(),
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIcon(BuildContext context) {
    if (icon != null) return icon!;

    switch (type) {
      case EmptyStateType.noResults:
        return Icons.search_off;
      case EmptyStateType.noProperties:
        return Icons.home_outlined;
      case EmptyStateType.noConversations:
        return Icons.chat_bubble_outline;
      case EmptyStateType.noNotifications:
        return Icons.notifications_off_outlined;
      case EmptyStateType.noFavorites:
        return Icons.favorite_outline;
      case EmptyStateType.networkError:
        return Icons.wifi_off;
      case EmptyStateType.serverError:
        return Icons.cloud_off;
      case EmptyStateType.generic:
        return Icons.inbox_outlined;
    }
  }

  Color _getIconColor(bool isDark) {
    switch (type) {
      case EmptyStateType.networkError:
      case EmptyStateType.serverError:
        return AppColors.error.withOpacity(0.6);
      default:
        return (isDark ? AppColors.white : AppColors.grey).withOpacity(0.5);
    }
  }

  String _getTitle(AppLocalizations l10n) {
    switch (type) {
      case EmptyStateType.noResults:
        return l10n.noResultsFound;
      case EmptyStateType.noProperties:
        return l10n.noPropertiesAvailable;
      case EmptyStateType.noConversations:
        return l10n.noConversations;
      case EmptyStateType.noNotifications:
        return l10n.noNotifications;
      case EmptyStateType.noFavorites:
        return 'Aucun favori';
      case EmptyStateType.networkError:
        return 'Pas de connexion';
      case EmptyStateType.serverError:
        return 'Erreur serveur';
      case EmptyStateType.generic:
        return 'Rien à afficher';
    }
  }

  String _getDescription(AppLocalizations l10n) {
    switch (type) {
      case EmptyStateType.noResults:
        return l10n.noResultsMessage;
      case EmptyStateType.noProperties:
        return 'Il n\'y a aucune propriété disponible pour le moment. Revenez plus tard ou modifiez vos critères de recherche.';
      case EmptyStateType.noConversations:
        return l10n.noConversationsMessage;
      case EmptyStateType.noNotifications:
        return l10n.noNotificationsMessage;
      case EmptyStateType.noFavorites:
        return 'Vous n\'avez pas encore ajouté de biens à vos favoris. Explorez les propriétés et marquez celles qui vous intéressent.';
      case EmptyStateType.networkError:
        return 'Vérifiez votre connexion internet et réessayez.';
      case EmptyStateType.serverError:
        return 'Nos serveurs rencontrent des difficultés. Veuillez réessayer dans quelques instants.';
      case EmptyStateType.generic:
        return 'Il n\'y a rien à afficher pour le moment.';
    }
  }

  bool _hasAction() {
    return [
      EmptyStateType.noResults,
      EmptyStateType.networkError,
      EmptyStateType.serverError,
      EmptyStateType.noConversations,
    ].contains(type);
  }

  String _getActionText(AppLocalizations l10n) {
    switch (type) {
      case EmptyStateType.noResults:
        return l10n.clearFiltersAndRetry;
      case EmptyStateType.networkError:
      case EmptyStateType.serverError:
        return l10n.retry;
      case EmptyStateType.noConversations:
        return 'Explorer les biens';
      default:
        return l10n.refresh;
    }
  }

  IconData _getActionIcon() {
    switch (type) {
      case EmptyStateType.noResults:
        return Icons.clear_all;
      case EmptyStateType.networkError:
      case EmptyStateType.serverError:
        return Icons.refresh;
      case EmptyStateType.noConversations:
        return Icons.home_outlined;
      default:
        return Icons.refresh;
    }
  }

  Color _getActionColor() {
    switch (type) {
      case EmptyStateType.networkError:
      case EmptyStateType.serverError:
        return AppColors.blue;
      default:
        return AppColors.orange;
    }
  }

  void _getDefaultAction(BuildContext context) {
    switch (type) {
      case EmptyStateType.noResults:
      // Clear filters (should be handled by parent)
        break;
      case EmptyStateType.networkError:
      case EmptyStateType.serverError:
      // Retry action (should be handled by parent)
        break;
      case EmptyStateType.noConversations:
      // Navigate to home
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      default:
      // Generic refresh action
        break;
    }
  }
}

// Factory constructors pour faciliter l'usage
class AppEmptyState {
  static Widget noResults({
    String? title,
    String? description,
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    return EmptyStateWidget(
      type: EmptyStateType.noResults,
      title: title,
      description: description,
      actionText: actionText,
      onActionPressed: onActionPressed,
    );
  }

  static Widget noProperties({
    String? title,
    String? description,
    VoidCallback? onRefresh,
  }) {
    return EmptyStateWidget(
      type: EmptyStateType.noProperties,
      title: title,
      description: description,
      onActionPressed: onRefresh,
      showAction: onRefresh != null,
    );
  }

  static Widget noConversations({
    String? title,
    String? description,
    VoidCallback? onExplore,
  }) {
    return EmptyStateWidget(
      type: EmptyStateType.noConversations,
      title: title,
      description: description,
      onActionPressed: onExplore,
    );
  }

  static Widget noNotifications({
    String? title,
    String? description,
  }) {
    return EmptyStateWidget(
      type: EmptyStateType.noNotifications,
      title: title,
      description: description,
      showAction: false,
    );
  }

  static Widget noFavorites({
    String? title,
    String? description,
    VoidCallback? onExplore,
  }) {
    return EmptyStateWidget(
      type: EmptyStateType.noFavorites,
      title: title,
      description: description,
      actionText: 'Explorer les biens',
      onActionPressed: onExplore,
    );
  }

  static Widget networkError({
    String? title,
    String? description,
    VoidCallback? onRetry,
  }) {
    return EmptyStateWidget(
      type: EmptyStateType.networkError,
      title: title,
      description: description,
      onActionPressed: onRetry,
    );
  }

  static Widget serverError({
    String? title,
    String? description,
    VoidCallback? onRetry,
  }) {
    return EmptyStateWidget(
      type: EmptyStateType.serverError,
      title: title,
      description: description,
      onActionPressed: onRetry,
    );
  }

  static Widget custom({
    required String title,
    required String description,
    required IconData icon,
    String? actionText,
    VoidCallback? onActionPressed,
    Color? iconColor,
  }) {
    return EmptyStateWidget(
      type: EmptyStateType.generic,
      title: title,
      description: description,
      icon: icon,
      actionText: actionText,
      onActionPressed: onActionPressed,
      showAction: onActionPressed != null,
    );
  }
}