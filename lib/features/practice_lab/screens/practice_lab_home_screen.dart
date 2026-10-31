import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../core/widgets/simulation_banner.dart';
import '../../../data/repositories/app_providers.dart';

/// TechSaathi Demo Bank Simulator Home Screen.
class PracticeLabHomeScreen extends ConsumerStatefulWidget {
  const PracticeLabHomeScreen({super.key});

  @override
  ConsumerState<PracticeLabHomeScreen> createState() => _PracticeLabHomeScreenState();
}

class _PracticeLabHomeScreenState extends ConsumerState<PracticeLabHomeScreen> {
  bool _showBalance = true;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final transactions = ref.watch(practiceTransactionsProvider);
    final currencyFormat = NumberFormat('#,##0.00', 'en_US');

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('TechSaathi Demo Bank', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'About Demo Bank',
            onPressed: () => _showAboutDemoBank(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Persistent Simulation Banner
              const SimulationBanner(),

              // Account Card (Mimics real mobile banking dashboard)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF168C83), Color(0xFF0F5B55)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A168C83),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Asaan Current Account',
                                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              _showBalance ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            tooltip: _showBalance ? 'Hide balance' : 'Show balance',
                            onPressed: () {
                              setState(() {
                                _showBalance = !_showBalance;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Available Balance',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _showBalance
                            ? 'PKR ${currencyFormat.format(profile.demoAccountBalance)}'
                            : 'PKR ••••••••',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Account Title', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 2),
                              Text(
                                profile.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Simulated IBAN', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              SizedBox(height: 2),
                              Text(
                                'PK92TECH...8901',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Quick Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionTile(
                        context,
                        title: 'Send Money',
                        subtitle: 'Simulate transfer',
                        icon: Icons.send_rounded,
                        color: AppColors.primaryBrand,
                        onTap: () => context.push('/practice-lab/transfer'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionTile(
                        context,
                        title: 'Pay Bills',
                        subtitle: 'Simulate utility bill',
                        icon: Icons.electric_bolt_rounded,
                        color: const Color(0xFFD97706),
                        onTap: () => context.push('/practice-lab/transfer?bill=true'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tutorial Guide Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AccessibleCard(
                  backgroundColor: AppColors.secondaryTeal.withOpacity(0.4),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.school_rounded, color: AppColors.primaryBrand, size: 30),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Beginner Learning Goal',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Practise sending PKR 1,500 to a friend and notice how the review screen works.',
                              style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBrand,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => context.push('/practice-lab/transfer'),
                        child: const Text('Try Now', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Recent Transactions Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Practice History', style: AppTextStyles.cardHeading),
                    TextButton(
                      onPressed: () => context.push('/practice-lab/history'),
                      child: const Text('View All', style: TextStyle(color: AppColors.primaryBrand, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              // Transactions List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: transactions.take(4).length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, idx) {
                  final tx = transactions[idx];
                  final isCredit = tx.type.contains('Credit');

                  return AccessibleCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isCredit ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                            color: isCredit ? AppColors.success : AppColors.danger,
                            size: 24,
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
                              const SizedBox(height: 2),
                              Text(
                                '${tx.type} • ${DateFormat('dd MMM yyyy').format(tx.timestamp)}',
                                style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${isCredit ? "+" : "-"} PKR ${currencyFormat.format(tx.amount)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isCredit ? AppColors.success : AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Reset Demo Balance Option
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.restart_alt_rounded, size: 20, color: AppColors.secondaryText),
                    label: const Text('Reset Demo Account Balance to PKR 50,000', style: TextStyle(color: AppColors.secondaryText)),
                    onPressed: () {
                      ref.read(userProfileProvider.notifier).updateDemoBalance(50000.0);
                      ref.read(practiceTransactionsProvider.notifier).refresh();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Demo Bank balance reset to PKR 50,000.00')),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AccessibleCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.secondaryText)),
        ],
      ),
    );
  }

  void _showAboutDemoBank(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('About TechSaathi Demo Bank'),
        content: const Text(
          'This is a 100% fictional banking simulation designed to build your confidence.\n\n'
          '• No real money is used.\n'
          '• No real banks are contacted.\n'
          '• You can practise as many times as you like without any financial risk.',
          style: TextStyle(fontSize: 15, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
