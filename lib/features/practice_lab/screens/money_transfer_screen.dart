import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_button.dart';
import '../../../core/widgets/simulation_banner.dart';
import '../../../data/repositories/app_providers.dart';

/// Simulated Money Transfer & Bill Payment Entry Screen with educational field guides.
class MoneyTransferScreen extends ConsumerStatefulWidget {
  final bool isBillPayment;

  const MoneyTransferScreen({super.key, this.isBillPayment = false});

  @override
  ConsumerState<MoneyTransferScreen> createState() => _MoneyTransferScreenState();
}

class _MoneyTransferScreenState extends ConsumerState<MoneyTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedBank = 'TechSaathi Demo Bank';
  bool _usedGuidanceHint = false;

  final List<String> _demoBanks = [
    'TechSaathi Demo Bank',
    'HBL Demo Bank',
    'Meezan Demo Bank',
    'JazzCash Demo Wallet',
    'Easypaisa Demo Wallet',
    'K-Electric Demo Billing',
    'LESCO Demo Billing',
    'SSGC Gas Demo Billing',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isBillPayment) {
      _selectedBank = 'K-Electric Demo Billing';
      _nameController.text = 'K-Electric Consumer';
      _accountController.text = '04000123456789';
      _amountController.text = '3850';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _fillSampleContact(String name, String acc, String bank, String amt) {
    setState(() {
      _nameController.text = name;
      _accountController.text = acc;
      _selectedBank = bank;
      _amountController.text = amt;
      _usedGuidanceHint = true;
    });
  }

  void _proceedToReview() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
      final profile = ref.read(userProfileProvider);

      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter an amount greater than 0')),
        );
        return;
      }

      if (amount > profile.demoAccountBalance) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Amount exceeds available demo balance of PKR ${profile.demoAccountBalance.toStringAsFixed(0)}',
            ),
          ),
        );
        return;
      }

      context.push(
        '/practice-lab/review',
        extra: {
          'recipientName': _nameController.text.trim(),
          'accountNumber': _accountController.text.trim(),
          'bankName': _selectedBank,
          'amount': amount,
          'type': widget.isBillPayment ? 'Bill Payment' : 'Money Transfer',
          'note': _noteController.text.trim(),
          'wasIndependent': !_usedGuidanceHint,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: Text(widget.isBillPayment ? 'Pay Utility Bill (Demo)' : 'Transfer Money (Demo)'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SimulationBanner(compact: true),
                const SizedBox(height: 16),

                // Tutorial Quick Fill Chips
                Text('Quick Practice Examples:', style: AppTextStyles.cardHeading),
                const SizedBox(height: 4),
                const Text(
                  'Tap any sample recipient below to fill the fields automatically, or type your own.',
                  style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.person, size: 18, color: AppColors.primaryBrand),
                      label: const Text('Tariq (Son) • PKR 1,500'),
                      onPressed: () => _fillSampleContact('Tariq (Son)', 'PK01TECH1122334455', 'HBL Demo Bank', '1500'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.phone_android, size: 18, color: AppColors.primaryBrand),
                      label: const Text('Fatima • JazzCash PKR 800'),
                      onPressed: () => _fillSampleContact('Fatima (Daughter)', '03001234567', 'JazzCash Demo Wallet', '800'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.lightbulb, size: 18, color: AppColors.warning),
                      label: const Text('Electricity Bill • PKR 2,400'),
                      onPressed: () => _fillSampleContact('K-Electric Bill', '04000987654321', 'K-Electric Demo Billing', '2400'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // FIELD 1: BANK SELECTION
                _buildFieldGuide(
                  title: '1. Select Bank or Service',
                  explanation: 'Pick the bank or wallet where the receiver holds their account.',
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 1.2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedBank,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryBrand),
                      items: _demoBanks
                          .map((b) => DropdownMenuItem(value: b, child: Text(b, style: AppTextStyles.bodyLarge)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedBank = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // FIELD 2: BENEFICIARY NAME
                _buildFieldGuide(
                  title: '2. Recipient / Beneficiary Name',
                  explanation: 'Beneficiary means the person who receives the money.',
                ),
                TextFormField(
                  controller: _nameController,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Tariq Mehmood, Fatima',
                    prefixIcon: Icon(Icons.person_rounded, color: AppColors.primaryBrand),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter recipient name' : null,
                ),
                const SizedBox(height: 18),

                // FIELD 3: ACCOUNT NUMBER / IBAN
                _buildFieldGuide(
                  title: '3. Account Number or IBAN',
                  explanation: 'Their unique 14 to 24 digit bank address or 11-digit mobile number.',
                ),
                TextFormField(
                  controller: _accountController,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'e.g. PK00TECH1234567890 or 03001234567',
                    prefixIcon: Icon(Icons.numbers_rounded, color: AppColors.primaryBrand),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter account number' : null,
                ),
                const SizedBox(height: 18),

                // FIELD 4: AMOUNT
                _buildFieldGuide(
                  title: '4. Amount to Transfer (PKR)',
                  explanation: 'Available demo balance: PKR ${profile.demoAccountBalance.toStringAsFixed(0)}',
                ),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: 'e.g. 1500',
                    prefixIcon: Icon(Icons.payments_rounded, color: AppColors.primaryBrand),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter amount';
                    final parsed = double.tryParse(v);
                    if (parsed == null || parsed <= 0) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // FIELD 5: NOTE (OPTIONAL)
                _buildFieldGuide(
                  title: '5. Purpose or Note (Optional)',
                  explanation: 'Helps you remember what this was for in your transaction history.',
                ),
                TextFormField(
                  controller: _noteController,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Grocery support, pocket money, medicine',
                    prefixIcon: Icon(Icons.note_alt_outlined, color: AppColors.primaryBrand),
                  ),
                ),
                const SizedBox(height: 28),

                // REVIEW BUTTON
                AccessibleButton(
                  label: 'Review Transaction',
                  icon: Icons.preview_rounded,
                  onPressed: _proceedToReview,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldGuide({required String title, required String explanation}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 2),
          Text(explanation, style: const TextStyle(fontSize: 13, color: AppColors.secondaryText)),
        ],
      ),
    );
  }
}
