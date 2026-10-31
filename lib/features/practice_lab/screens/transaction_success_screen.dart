import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_button.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../core/widgets/simulation_banner.dart';

/// Transaction Success Receipt Screen celebrating practice achievement.
class TransactionSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> transactionData;

  const TransactionSuccessScreen({super.key, required this.transactionData});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat('#,##0.00', 'en_US');
    final amount = transactionData['amount'] as double;
    final now = DateTime.now();
    final refNumber = 'TS-SIM-${now.millisecondsSinceEpoch.toString().substring(6)}';
    final wasIndependent = transactionData['wasIndependent'] as bool? ?? false;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Transaction Receipt'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const SimulationBanner(compact: true),
              const SizedBox(height: 20),

              // Animated Success Check Icon
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 54),
              ),
              const SizedBox(height: 16),
              Text(
                'Simulated Transfer Successful!',
                style: AppTextStyles.headingLarge.copyWith(color: AppColors.success, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'You have safely completed a mock digital payment.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),

              if (wasIndependent) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryTeal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.military_tech_rounded, color: AppColors.primaryBrand, size: 22),
                      SizedBox(width: 8),
                      Text(
                        '+1 Independent Practice Score Recorded!',
                        style: TextStyle(color: AppColors.primaryBrand, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Digital Receipt Card
              AccessibleCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Amount Sent', style: TextStyle(color: AppColors.secondaryText, fontSize: 15)),
                        Text(
                          'PKR ${currency.format(amount)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primaryBrand),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: AppColors.border),
                    _buildReceiptItem('Reference ID', refNumber),
                    const SizedBox(height: 10),
                    _buildReceiptItem('Date & Time', DateFormat('dd MMM yyyy, hh:mm a').format(now)),
                    const SizedBox(height: 10),
                    _buildReceiptItem('Recipient', transactionData['recipientName'] as String),
                    const SizedBox(height: 10),
                    _buildReceiptItem('Bank / Service', transactionData['bankName'] as String),
                    const SizedBox(height: 10),
                    _buildReceiptItem('Account Number', transactionData['accountNumber'] as String),
                    const SizedBox(height: 10),
                    _buildReceiptItem('Status', 'Success (Simulated)'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Share / Save Receipt Mock Action
              AccessibleButton(
                label: 'Save / Share Receipt',
                icon: Icons.share_rounded,
                type: AccessibleButtonType.secondary,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Simulated receipt shared to WhatsApp/Saved to gallery.'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Done Button
              AccessibleButton(
                label: 'Back to Demo Bank Home',
                icon: Icons.home_rounded,
                onPressed: () => context.go('/practice-lab'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryText)),
      ],
    );
  }
}
