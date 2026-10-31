import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../data/repositories/app_providers.dart';

/// Banking Saathi Curriculum Overview Screen (14 Bite-sized Lessons).
class BankingSaathiScreen extends ConsumerWidget {
  const BankingSaathiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(bankingLessonsProvider);
    final profile = ref.watch(userProfileProvider);
    final isUrdu = profile.preferredLanguage == 'ur';

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Banking Saathi', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryTeal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${profile.completedLessonIds.length} / ${lessons.length} done',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBrand,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                isUrdu ? 'بینکاری سیکھیں، قدم بہ قدم' : 'Learn Banking, Step by Step.',
                style: isUrdu
                    ? AppTextStyles.urduHeading(fontSize: 26)
                    : AppTextStyles.headingLarge.copyWith(color: AppColors.primaryBrand),
              ),
              const SizedBox(height: 6),
              Text(
                isUrdu
                    ? 'بغیر کسی خوف کے ڈیجیٹل بینکنگ کو سمجھیں۔'
                    : 'Understand digital banking without fear.',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 18),

              // Practice Lab Callout Banner
              AccessibleCard(
                backgroundColor: AppColors.secondaryTeal.withOpacity(0.5),
                padding: const EdgeInsets.all(16),
                onTap: () => context.push('/practice-lab'),
                child: const Row(
                  children: [
                    Icon(Icons.biotech_rounded, size: 36, color: AppColors.primaryBrand),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Demo Bank Practice Lab',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Practise simulated transfers with PKR 50,000 risk-free.',
                            style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded, color: AppColors.primaryBrand),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 14 Lessons List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lessons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final lesson = lessons[i];
                  final isCompleted = profile.completedLessonIds.contains(lesson.id);

                  return AccessibleCard(
                    padding: const EdgeInsets.all(16),
                    onTap: () => context.push('/banking-saathi/${lesson.id}'),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Order Number badge or Completed Check
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: isCompleted ? AppColors.success : AppColors.secondaryTeal,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 26)
                                : Text(
                                    '${lesson.order}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.primaryBrand,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Title & Summary
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isUrdu ? lesson.titleUrdu : lesson.title,
                                style: AppTextStyles.cardHeading.copyWith(fontSize: 17),
                              ),
                              if (!isUrdu) ...[
                                const SizedBox(height: 2),
                                Text(
                                  lesson.titleUrdu,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                isUrdu ? lesson.summaryUrdu : lesson.summary,
                                style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: AppColors.secondaryText,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
