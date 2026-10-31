import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum AccessibleButtonType { primary, secondary, outline }

/// Accessible Button strictly adhering to the 56x56 minimum touch target.
class AccessibleButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final AccessibleButtonType type;
  final bool isLoading;
  final double? width;

  const AccessibleButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.type = AccessibleButtonType.primary,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? double.infinity;

    Color bgColor;
    Color fgColor;
    BorderSide borderSide = BorderSide.none;

    switch (type) {
      case AccessibleButtonType.primary:
        bgColor = AppColors.primaryBrand;
        fgColor = Colors.white;
        break;
      case AccessibleButtonType.secondary:
        bgColor = AppColors.secondaryTeal;
        fgColor = AppColors.primaryBrand;
        break;
      case AccessibleButtonType.outline:
        bgColor = Colors.transparent;
        fgColor = AppColors.primaryBrand;
        borderSide = const BorderSide(color: AppColors.primaryBrand, width: 1.6);
        break;
    }

    return SizedBox(
      width: effectiveWidth,
      height: 56, // Strict 56 minimum touch target
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          side: borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 24, color: fgColor),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: fgColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
