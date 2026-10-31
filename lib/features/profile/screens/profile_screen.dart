import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../data/repositories/app_providers.dart';

/// Profile & Settings Screen with accessible toggles for language and voice.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = ref.read(userProfileProvider).name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Profile & Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar & Name Card
              AccessibleCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryTeal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded, color: AppColors.primaryBrand, size: 38),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.name, style: AppTextStyles.cardHeading.copyWith(fontSize: 20)),
                          const SizedBox(height: 2),
                          const Text(
                            'Independent Digital Learner',
                            style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Active Streak: ${profile.learningStreak} days',
                            style: const TextStyle(color: AppColors.primaryBrand, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // NAME EDIT
              Text('Your Preferred Name', style: AppTextStyles.cardHeading),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      style: AppTextStyles.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: 'Enter name',
                        prefixIcon: Icon(Icons.badge_outlined, color: AppColors.primaryBrand),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrand,
                      minimumSize: const Size(80, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      notifier.completeOnboarding(_nameController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Name updated successfully')),
                      );
                    },
                    child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // PREFERRED LANGUAGE
              Text('Preferred Language', style: AppTextStyles.cardHeading),
              const SizedBox(height: 8),
              AccessibleCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  children: [
                    _buildRadioRow(
                      label: 'Roman Urdu (Urdu in English alphabet)',
                      value: 'ur-roman',
                      groupValue: profile.preferredLanguage,
                      onChanged: (val) => notifier.updateLanguage(val!),
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _buildRadioRow(
                      label: 'اردو (Urdu Noto Nastaliq)',
                      value: 'ur',
                      groupValue: profile.preferredLanguage,
                      onChanged: (val) => notifier.updateLanguage(val!),
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _buildRadioRow(
                      label: 'English (Friendly & Simple)',
                      value: 'en',
                      groupValue: profile.preferredLanguage,
                      onChanged: (val) => notifier.updateLanguage(val!),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // LEARNING STYLE PREFERENCE
              Text('Teaching Style', style: AppTextStyles.cardHeading),
              const SizedBox(height: 8),
              AccessibleCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  children: [
                    _buildRadioRow(
                      label: 'Both Voice & Text (Recommended)',
                      value: 'both',
                      groupValue: profile.learningStyle,
                      onChanged: (val) => notifier.updateLearningStyle(val!),
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _buildRadioRow(
                      label: 'Voice Explanations Aloud',
                      value: 'voice',
                      groupValue: profile.learningStyle,
                      onChanged: (val) => notifier.updateLearningStyle(val!),
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _buildRadioRow(
                      label: 'Step-by-step Text Only',
                      value: 'text',
                      groupValue: profile.learningStyle,
                      onChanged: (val) => notifier.updateLearningStyle(val!),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // PRIVACY & SECURITY
              Text('Privacy & Safety Policy', style: AppTextStyles.cardHeading),
              const SizedBox(height: 8),
              const AccessibleCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock_rounded, color: AppColors.primaryBrand, size: 22),
                        SizedBox(width: 8),
                        Text('Zero Financial Access Guarantee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• TechSaathi never connects to real bank accounts or holds real money.\n'
                      '• We will NEVER prompt for or store ATM PINs, OTP codes, or passwords.\n'
                      '• Screenshots submitted for explanation are processed ephemerally and never stored.',
                      style: TextStyle(fontSize: 14, height: 1.4, color: AppColors.primaryText),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ABOUT TECHSAATHI
              const AccessibleCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About TechSaathi AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 6),
                    Text(
                      'Version 1.0.0+1 (Hackathon Release)\n'
                      'Technology Made Simple. Independence Made Possible.\n'
                      'Designed with care for parents, grandparents, and digital beginners.',
                      style: TextStyle(fontSize: 14, color: AppColors.secondaryText, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // RESET / LOGOUT BUTTON
              AccessibleCard(
                borderColor: AppColors.danger.withOpacity(0.4),
                child: Row(
                  children: [
                    const Icon(Icons.restart_alt_rounded, color: AppColors.danger, size: 28),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reset Learning & Restart Onboarding', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.danger)),
                          Text('Clears local progress for fresh demo testing', style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showResetDialog(context, notifier),
                      child: const Text('Reset', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioRow({
    required String label,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return RadioListTile<String>(
      title: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      value: value,
      groupValue: groupValue,
      activeColor: AppColors.primaryBrand,
      contentPadding: EdgeInsets.zero,
      onChanged: onChanged,
    );
  }

  void _showResetDialog(BuildContext context, UserProfileNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset All Learning Progress?'),
        content: const Text(
          'This will clear saved quiz scores, reset the Demo Bank balance to PKR 50,000, and show the onboarding questions again.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              Navigator.pop(ctx);
              await notifier.resetAll();
              if (context.mounted) {
                context.go('/onboarding');
              }
            },
            child: const Text('Reset Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
