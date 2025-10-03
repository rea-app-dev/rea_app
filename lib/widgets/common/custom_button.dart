import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

enum ButtonType { primary, secondary, outline, text, danger }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final Color? customColor;
  final Color? customTextColor;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.customColor,
    this.customTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget button = _buildButton(context, isDark);

    if (isExpanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildButton(BuildContext context, bool isDark) {
    switch (type) {
      case ButtonType.primary:
        return _buildElevatedButton(context, isDark);
      case ButtonType.secondary:
        return _buildSecondaryButton(context, isDark);
      case ButtonType.outline:
        return _buildOutlinedButton(context, isDark);
      case ButtonType.text:
        return _buildTextButton(context, isDark);
      case ButtonType.danger:
        return _buildDangerButton(context, isDark);
    }
  }

  Widget _buildElevatedButton(BuildContext context, bool isDark) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: _buildIcon(),
      label: _buildLabel(),
      style: ElevatedButton.styleFrom(
        backgroundColor: customColor ?? AppColors.orange,
        foregroundColor: customTextColor ?? AppColors.white,
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        elevation: 2,
        disabledBackgroundColor: AppColors.grey.withOpacity(0.3),
        disabledForegroundColor: AppColors.grey,
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, bool isDark) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: _buildIcon(),
      label: _buildLabel(),
      style: ElevatedButton.styleFrom(
        backgroundColor: customColor ?? (isDark ? AppColors.darkGrey : AppColors.lightGrey),
        foregroundColor: customTextColor ?? (isDark ? AppColors.white : AppColors.blue),
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        elevation: 1,
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, bool isDark) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: _buildIcon(),
      label: _buildLabel(),
      style: OutlinedButton.styleFrom(
        foregroundColor: customColor ?? AppColors.orange,
        side: BorderSide(
          color: customColor ?? AppColors.orange,
          width: 1.5,
        ),
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isDark) {
    return TextButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: _buildIcon(),
      label: _buildLabel(),
      style: TextButton.styleFrom(
        foregroundColor: customColor ?? AppColors.orange,
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
    );
  }

  Widget _buildDangerButton(BuildContext context, bool isDark) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: _buildIcon(),
      label: _buildLabel(),
      style: ElevatedButton.styleFrom(
        backgroundColor: customColor ?? AppColors.error,
        foregroundColor: customTextColor ?? AppColors.white,
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(
            type == ButtonType.outline || type == ButtonType.text
                ? (customColor ?? AppColors.orange)
                : (customTextColor ?? AppColors.white),
          ),
        ),
      );
    }

    if (icon != null) {
      return Icon(icon, size: _getIconSize());
    }

    return const SizedBox.shrink();
  }

  Widget _buildLabel() {
    return Text(
      text,
      style: TextStyle(
        fontSize: _getFontSize(),
        fontWeight: _getFontWeight(),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case ButtonSize.small:
        return 6;
      case ButtonSize.medium:
        return 8;
      case ButtonSize.large:
        return 12;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.medium:
        return 14;
      case ButtonSize.large:
        return 16;
    }
  }

  FontWeight _getFontWeight() {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.danger:
        return FontWeight.w600;
      case ButtonType.secondary:
      case ButtonType.outline:
        return FontWeight.w500;
      case ButtonType.text:
        return FontWeight.w400;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 18;
      case ButtonSize.large:
        return 20;
    }
  }
}

// Factory constructors pour plus de simplicité
class AppButton {
  static Widget primary({
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      size: size,
      isLoading: isLoading,
      isExpanded: isExpanded,
      icon: icon,
    );
  }

  static Widget secondary({
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.secondary,
      size: size,
      isLoading: isLoading,
      isExpanded: isExpanded,
      icon: icon,
    );
  }

  static Widget outline({
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
    Color? color,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.outline,
      size: size,
      isLoading: isLoading,
      isExpanded: isExpanded,
      icon: icon,
      customColor: color,
    );
  }

  static Widget text({
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
    Color? color,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.text,
      size: size,
      isLoading: isLoading,
      icon: icon,
      customColor: color,
    );
  }

  static Widget danger({
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isExpanded = false,
    IconData? icon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.danger,
      size: size,
      isLoading: isLoading,
      isExpanded: isExpanded,
      icon: icon,
    );
  }
}