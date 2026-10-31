import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Persistent Warning Banner for Banking Practice Lab.
class SimulationBanner extends StatelessWidget {
  final bool compact;

  const SimulationBanner({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        color: const Color(0xFFFFF7ED), // Soft amber tint
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, color: AppColors.warning, size: 20),
            SizedBox(width: 8),
            Text(
              'SIMULATION ONLY — NO REAL MONEY',
              style: TextStyle(
                color: Color(0xFF9A3412),
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_reset, color: AppColors.warning, size: 26),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIMULATION ONLY — NO REAL MONEY',
                  style: TextStyle(
                    color: Color(0xFF92400E),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'This is a safe learning sandbox. No real bank accounts, real transfers, or money are ever connected. Practise freely without fear.',
                  style: TextStyle(
                    color: Color(0xFF78350F),
                    fontSize: 14,
                    height: 1.35,
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
