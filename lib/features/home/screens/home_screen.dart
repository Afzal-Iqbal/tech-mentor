import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../core/widgets/tech_saathi_logo.dart';
import '../../../data/repositories/app_providers.dart';

/// Clean, welcoming, beginner-friendly Home Dashboard.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final isUrdu = profile.preferredLanguage == 'ur';

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        title: const TechSaathiLogo(size: 38, showText: true),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => context.push('/profile'),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryTeal,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryBrand.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryBrand,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUrdu ? 'السلام علیکم!' : 'Assalam-o-Alaikum,',
                          style: isUrdu
                              ? AppTextStyles.urduHeading(fontSize: 24)
                              : AppTextStyles.headingMedium.copyWith(color: AppColors.primaryBrand),
                        ),
                        Text(
                          profile.name,
                          style: AppTextStyles.headingLarge.copyWith(height: 1.1),
                        ),
                      ],
                    ),
                  ),
                  // Friendly visual indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryTeal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_fire_department_rounded, color: AppColors.warning, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${profile.learningStreak} Day Streak',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // MAIN ACTION CARD: "How can I help you today?"
              AccessibleCard(
                backgroundColor: AppColors.primaryBrand,
                borderColor: AppColors.primaryBrand,
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.school_rounded, color: Colors.white, size: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isUrdu ? 'آج آپ کیا سیکھنا چاہتے ہیں؟' : 'How can I help you today?',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isUrdu
                          ? 'مائیکروفون دبائیں یا سوال لکھ کر پوچھیں'
                          : 'Ask anything about WhatsApp, your phone, or banking.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        // Large Microphone Button
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primaryBrand,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () => context.push('/ai-teacher?voice=true'),
                              icon: const Icon(Icons.mic_rounded, size: 28, color: AppColors.primaryBrand),
                              label: const Text(
                                'Speak Now',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBrand,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Text Question Button
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 56,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white70, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () => context.push('/ai-teacher'),
                              icon: const Icon(Icons.edit_note_rounded, size: 24, color: Colors.white),
                              label: const Text(
                                'Type',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Explore TechSaathi',
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: 4),
              const Text(
                'Tap any card below to start learning step-by-step.',
                style: TextStyle(fontSize: 15, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 14),

              // ONLY FOUR PRIMARY CARDS
              // CARD 1: AI Teacher
              _buildFeatureCard(
                context,
                title: 'AI Teacher',
                titleUrdu: 'اے آئی استاد',
                description: 'Ask anything about technology with voice or text.',
                icon: Icons.smart_toy_rounded,
                iconColor: const Color(0xFF0284C7),
                bgColor: const Color(0xFFF0F9FF),
                onTap: () => context.push('/ai-teacher'),
              ),
              const SizedBox(height: 12),

              // CARD 2: Banking Saathi
              _buildFeatureCard(
                context,
                title: 'Banking Saathi',
                titleUrdu: 'بینکنگ ساتھی',
                description: 'Learn to use banking applications safely without fear.',
                icon: Icons.account_balance_rounded,
                iconColor: AppColors.primaryBrand,
                bgColor: AppColors.secondaryTeal.withOpacity(0.4),
                onTap: () => context.push('/banking-saathi'),
              ),
              const SizedBox(height: 12),

              // CARD 3: ScamShield
              _buildFeatureCard(
                context,
                title: 'ScamShield',
                titleUrdu: 'اسکیم شیلڈ (فراڈ سے حفاظت)',
                description: 'Check suspicious SMS, WhatsApp forwards, and lottery calls.',
                icon: Icons.gpp_maybe_rounded,
                iconColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFFFBEB),
                onTap: () => context.push('/scamshield'),
              ),
              const SizedBox(height: 12),

              // CARD 4: Explain My Screen
              _buildFeatureCard(
                context,
                title: 'Explain My Screen',
                titleUrdu: 'میری اسکرین سمجھائیں',
                description: 'Understand confusing phone screens and buttons safely.',
                icon: Icons.screenshot_monitor_rounded,
                iconColor: const Color(0xFF7C3AED),
                bgColor: const Color(0xFFF5F3FF),
                onTap: () => context.push('/screen-explainer'),
              ),

              const SizedBox(height: 24),

              // CONTINUE LEARNING SECTION
              Text(
                'Continue Learning',
                style: AppTextStyles.cardHeading,
              ),
              const SizedBox(height: 10),
              AccessibleCard(
                onTap: () => context.push('/banking-saathi/lesson_1_mobile_banking'),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryTeal,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.play_circle_fill_rounded, color: AppColors.primaryBrand, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lesson 1: Understanding Mobile Banking',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.completedLessonIds.contains('lesson_1_mobile_banking')
                                ? 'Completed! Tap to review anytime.'
                                : 'In progress • 3 min read & practice',
                            style: TextStyle(
                              fontSize: 14,
                              color: profile.completedLessonIds.contains('lesson_1_mobile_banking')
                                  ? AppColors.success
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppColors.secondaryText),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // YOUR LEARNING PROGRESS SECTION
              Text(
                'Your Learning Progress',
                style: AppTextStyles.cardHeading,
              ),
              const SizedBox(height: 10),
              AccessibleCard(
                padding: const EdgeInsets.all(18),
                onTap: () => context.go('/progress'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${profile.lessonsCompleted} of 14 Banking Lessons Completed',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          '${((profile.lessonsCompleted / 14) * 100).toInt()}%',
                          style: const TextStyle(
                            color: AppColors.primaryBrand,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (profile.lessonsCompleted / 14).clamp(0.05, 1.0),
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBrand),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.verified_rounded, color: AppColors.success, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '${profile.independentTasksCount} independent practice tasks completed!',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String titleUrdu,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return AccessibleCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cardHeading,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '($titleUrdu)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 14),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.secondaryText,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
