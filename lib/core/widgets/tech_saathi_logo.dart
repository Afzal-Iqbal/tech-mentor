import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// TechSaathi AI Brand Logo:
/// Clean minimal vector symbol combining a helping hand, digital connection node, and educational sprout.
class TechSaathiLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isDark;

  const TechSaathiLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primaryBrand,
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBrand.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Digital connection circle
              Container(
                width: size * 0.65,
                height: size * 0.65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondaryTeal.withOpacity(0.4),
                    width: 2,
                  ),
                ),
              ),
              // Helping hand / education icon
              Icon(
                Icons.volunteer_activism_rounded,
                color: Colors.white,
                size: size * 0.52,
              ),
            ],
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'TechSaathi',
                    style: TextStyle(
                      fontSize: size * 0.44,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.primaryText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryTeal,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'AI',
                      style: TextStyle(
                        fontSize: size * 0.26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBrand,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Digital & Banking Teacher',
                style: TextStyle(
                  fontSize: size * 0.24,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
