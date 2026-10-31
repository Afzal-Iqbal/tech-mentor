import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../core/widgets/simulation_banner.dart';
import '../../../data/repositories/app_providers.dart';

/// Full Transaction History View for Demo Bank.
class TransactionHistoryScreen extends ConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(practiceTransactionsProvider);
    final currency = NumberFormat('#,##0.00', 'en_US');

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Simulated Passbook History'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SimulationBanner(compact: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 20, color: AppColors.secondaryText),
                  const SizedBox(width: 8),
                  Text(
                    'Green (+) = Received  •  Red (-) = Sent or Paid',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                      child: Text('No transactions yet.', style: AppTextStyles.bodyLarge),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: transactions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, idx) {
                        final tx = transactions[idx];
                        final isCredit = tx.type.contains('Credit');

                        return AccessibleCard(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isCredit ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                  color: isCredit ? AppColors.success : AppColors.danger,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.recipientName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${tx.bankName} • ${DateFormat('dd MMM yyyy, hh:mm a').format(tx.timestamp)}',
                                      style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                                    ),
                                    if (tx.note.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        'Note: ${tx.note}',
                                        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.secondaryText),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${isCredit ? "+" : "-"} PKR ${currency.format(tx.amount)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isCredit ? AppColors.success : AppColors.danger,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    tx.status,
                                    style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
