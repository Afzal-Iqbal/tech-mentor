import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/accessible_button.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../core/widgets/simulation_banner.dart';
import '../../../data/repositories/app_providers.dart';

/// Transaction Review Screen teaching calm verification before confirming.
class TransactionReviewScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> transactionData;

  const TransactionReviewScreen({super.key, required this.transactionData});

  @override
  ConsumerState<TransactionReviewScreen> createState() => _TransactionReviewScreenState();
}

class _TransactionReviewScreenState extends ConsumerState<TransactionReviewScreen> {
  bool _isProcessing = false;

  Future<void> _confirmTransfer() async {
    setState(() {
      _isProcessing = true;
    });

    final data = widget.transactionData;
    final notifier = ref.read(practiceTransactionsProvider.notifier);

    await notifier.makeTransfer(
      recipientName: data['recipientName'] as String,
      accountNumber: data['accountNumber'] as String,
      bankName: data['bankName'] as String,
      amount: data['amount'] as double,
      type: data['type'] as String,
      note: data['note'] as String? ?? '',
      wasIndependent: data['wasIndependent'] as bool? ?? false,
    );

    if (mounted) {
      context.pushReplacement(
        '/practice-lab/success',
        extra: data,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.transactionData;
    final currency = NumberFormat('#,##0.00', 'en_US');
    final amount = data['amount'] as double;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Review Transaction'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SimulationBanner(compact: true),
              const SizedBox(height: 16),

              // Educational Review Advice Card
              const AccessibleCard(
                backgroundColor: Color(0xFFF0FDF4),
                borderColor: Color(0xFF86EFAC),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.verified_user_rounded, color: AppColors.success, size: 30),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Step 4: The Golden Review Step',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.success),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Take 10 seconds to read every line below calmly. Make sure the name and amount match your intent.',
                            style: TextStyle(fontSize: 14, color: AppColors.primaryText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Review Details Card
              AccessibleCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Amount Highlight
                    Text(
                      'PKR ${currency.format(amount)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBrand,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data['type'] as String,
                      style: const TextStyle(fontSize: 14, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 16),

                    _buildReviewRow('Beneficiary / Recipient', data['recipientName'] as String, isBold: true),
                    const SizedBox(height: 12),
                    _buildReviewRow('Bank / Wallet', data['bankName'] as String),
                    const SizedBox(height: 12),
                    _buildReviewRow('Account / IBAN', data['accountNumber'] as String),
                    const SizedBox(height: 12),
                    _buildReviewRow('Transfer Fee', 'PKR 0.00 (Free Demo)'),
                    if ((data['note'] as String? ?? '').isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildReviewRow('Note', data['note'] as String),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Confirm Button
              AccessibleButton(
                label: 'Confirm Simulated Transfer',
                icon: Icons.check_circle_rounded,
                isLoading: _isProcessing,
                onPressed: _confirmTransfer,
              ),
              const SizedBox(height: 12),

              // Cancel / Edit Button
              AccessibleButton(
                label: 'Edit Details / Cancel',
                icon: Icons.arrow_back_rounded,
                type: AccessibleButtonType.outline,
                onPressed: () => context.pop(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, color: AppColors.secondaryText)),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }
}
