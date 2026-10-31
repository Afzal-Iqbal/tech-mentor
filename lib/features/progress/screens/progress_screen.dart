import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../data/repositories/app_providers.dart';

/// My Progress Dashboard: Independence tracking, milestones, and badges.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final lessons = ref.watch(bankingLessonsProvider);

    final totalBankingLessons = lessons.length;
    final completedCount = profile.completedLessonIds.length;
    final independenceScore = profile.independentTasksCount;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('My Learning Progress', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Friendly Encouragement Hero Card
              AccessibleCard(
                backgroundColor: AppColors.primaryBrand,
                borderColor: AppColors.primaryBrand,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: AppColors.warning, size: 32),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Shabash, ${profile.name}!',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      completedCount > 0
                          ? 'You are steadily mastering everyday technology. Every step builds your confidence!'
                          : 'Welcome to your learning journey! Take your first lesson today.',
                      style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.35),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: AppColors.warning, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '${profile.learningStreak} Day Active Streak',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // KEY METRICS 3-COLUMN SUMMARY
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Lessons Done',
                      value: '$completedCount / $totalBankingLessons',
                      icon: Icons.menu_book_rounded,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Practice Runs',
                      value: '${profile.practiceCompleted}',
                      icon: Icons.account_balance_rounded,
                      color: const Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Independent',
                      value: '$independenceScore',
                      icon: Icons.military_tech_rounded,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // INDEPENDENCE TRACKING CARD
              AccessibleCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.workspace_premium_rounded, color: AppColors.primaryBrand, size: 26),
                        SizedBox(width: 10),
                        Text(
                          'Independence Metric',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This measures tasks you completed independently without hints or guided step assistance.',
                      style: TextStyle(fontSize: 14, color: AppColors.secondaryText, height: 1.3),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$independenceScore tasks completed on your own', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('${(independenceScore * 20).clamp(0, 100)}% Mastered', style: const TextStyle(color: AppColors.primaryBrand, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (independenceScore / 5).clamp(0.05, 1.0),
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ACHIEVEMENT BADGES
              Text('Your Earned Milestone Badges', style: AppTextStyles.cardHeading),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildBadge(
                    title: 'Welcome Starter',
                    desc: 'Joined TechSaathi AI',
                    isUnlocked: true,
                    icon: Icons.celebration_rounded,
                  ),
                  _buildBadge(
                    title: 'First Bank Step',
                    desc: 'Completed Lesson 1',
                    isUnlocked: profile.completedLessonIds.contains('lesson_1_mobile_banking'),
                    icon: Icons.account_balance_rounded,
                  ),
                  _buildBadge(
                    title: 'Sandbox Explorer',
                    desc: 'Practised Demo Transfer',
                    isUnlocked: profile.practiceCompleted > 0,
                    icon: Icons.biotech_rounded,
                  ),
                  _buildBadge(
                    title: 'Scam Spotter',
                    desc: 'Scanned a Message',
                    isUnlocked: true,
                    icon: Icons.gpp_good_rounded,
                  ),
                  _buildBadge(
                    title: 'Independent Hero',
                    desc: '3+ Solo Practice Tasks',
                    isUnlocked: profile.independentTasksCount >= 3,
                    icon: Icons.military_tech_rounded,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // SKILLS TO PRACTISE NEXT
              Text('Recommended Practice Next', style: AppTextStyles.cardHeading),
              const SizedBox(height: 10),
              AccessibleCard(
                onTap: () => context.push('/practice-lab/transfer'),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_rounded, color: AppColors.warning, size: 28),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Simulate a Money Transfer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 2),
                          Text('Practise entering beneficiary name and checking the review screen.', style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBrand,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () => context.push('/practice-lab/transfer'),
                      child: const Text('Practise', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
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

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String title,
    required String desc,
    required bool isUnlocked,
    required IconData icon,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnlocked ? AppColors.secondaryTeal : AppColors.border,
          width: 1.4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: isUnlocked ? AppColors.primaryBrand : Colors.black26, size: 26),
              const Spacer(),
              Icon(
                isUnlocked ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                color: isUnlocked ? AppColors.success : Colors.black26,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isUnlocked ? AppColors.primaryText : Colors.black38,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: TextStyle(
              fontSize: 12,
              color: isUnlocked ? AppColors.secondaryText : Colors.black26,
            ),
          ),
        ],
      ),
    );
  }
}
