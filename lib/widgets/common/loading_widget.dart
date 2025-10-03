import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/colors.dart';

enum LoadingType { circular, linear, dots, skeleton }

class LoadingWidget extends StatefulWidget {
  final LoadingType type;
  final String? message;
  final Color? color;
  final double? size;
  final bool showMessage;

  const LoadingWidget({
    Key? key,
    this.type = LoadingType.circular,
    this.message,
    this.color,
    this.size,
    this.showMessage = true,
  }) : super(key: key);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late AnimationController _skeletonController;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _skeletonController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _skeletonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLoadingIndicator(isDark),
          if (widget.showMessage) ...[
            const SizedBox(height: 16),
            Text(
              widget.message ?? l10n.loading,
              style: TextStyle(
                color: widget.color ?? AppColors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(bool isDark) {
    switch (widget.type) {
      case LoadingType.circular:
        return _buildCircularLoader();
      case LoadingType.linear:
        return _buildLinearLoader();
      case LoadingType.dots:
        return _buildDotsLoader();
      case LoadingType.skeleton:
        return _buildSkeletonLoader(isDark);
    }
  }

  Widget _buildCircularLoader() {
    return SizedBox(
      width: widget.size ?? 40,
      height: widget.size ?? 40,
      child: CircularProgressIndicator(
        color: widget.color ?? AppColors.orange,
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildLinearLoader() {
    return SizedBox(
      width: widget.size ?? 200,
      child: LinearProgressIndicator(
        color: widget.color ?? AppColors.orange,
        backgroundColor: AppColors.lightGrey,
      ),
    );
  }

  Widget _buildDotsLoader() {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = Curves.easeInOut.transform(
              (((_dotsController.value - delay) % 1.0).clamp(0.0, 1.0)),
            );

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.scale(
                scale: 0.5 + (animationValue * 0.5),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: (widget.color ?? AppColors.orange)
                        .withOpacity(0.3 + (animationValue * 0.7)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSkeletonLoader(bool isDark) {
    return AnimatedBuilder(
      animation: _skeletonController,
      builder: (context, child) {
        return Container(
          width: widget.size ?? 200,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment(-1.0, 0.0),
              end: Alignment(1.0, 0.0),
              colors: [
                isDark
                    ? AppColors.darkGrey
                    : AppColors.lightGrey,
                isDark
                    ? AppColors.darkGrey.withOpacity(0.5)
                    : Colors.white,
                isDark
                    ? AppColors.darkGrey
                    : AppColors.lightGrey,
              ],
              stops: [
                0.0,
                _skeletonController.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widgets de loading spécialisés
class PropertyCardSkeleton extends StatelessWidget {
  const PropertyCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkGrey : AppColors.lightGrey,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),

          // Content skeleton
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title skeleton
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkGrey : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),

                // Location skeleton
                Container(
                  height: 12,
                  width: 120,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkGrey : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),

                // Price skeleton
                Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkGrey : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageSkeleton extends StatelessWidget {
  final bool isMe;

  const ChatMessageSkeleton({
    Key? key,
    this.isMe = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: isDark ? AppColors.darkGrey : AppColors.lightGrey,
            ),
            const SizedBox(width: 8),
          ],

          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkGrey : AppColors.lightGrey,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkGrey.withOpacity(0.5) : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 14,
                  width: 60,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkGrey.withOpacity(0.5) : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          if (isMe) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.done,
              size: 16,
              color: isDark ? AppColors.darkGrey : AppColors.lightGrey,
            ),
          ],
        ],
      ),
    );
  }
}

// Factory constructors pour faciliter l'usage
class AppLoading {
  static Widget circular({
    String? message,
    Color? color,
    double? size,
  }) {
    return LoadingWidget(
      type: LoadingType.circular,
      message: message,
      color: color,
      size: size,
    );
  }

  static Widget dots({
    String? message,
    Color? color,
  }) {
    return LoadingWidget(
      type: LoadingType.dots,
      message: message,
      color: color,
    );
  }

  static Widget linear({
    String? message,
    Color? color,
    double? width,
  }) {
    return LoadingWidget(
      type: LoadingType.linear,
      message: message,
      color: color,
      size: width,
    );
  }

  static Widget skeleton({
    String? message,
    double? size,
  }) {
    return LoadingWidget(
      type: LoadingType.skeleton,
      message: message,
      size: size,
      showMessage: message != null,
    );
  }
}