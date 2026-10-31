import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../data/models/learning_lesson.dart';
import '../../../data/repositories/app_providers.dart';

/// Digital Literacy Learning Hub: Browse categories and bite-sized lessons.
class LearningScreen extends ConsumerWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(generalCurriculumProvider);
    final profile = ref.watch(userProfileProvider);
    final isUrdu = profile.preferredLanguage == 'ur';

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Digital Learning', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUrdu ? 'ڈیجیٹل مہارتیں سیکھیں' : 'Everyday Digital Skills',
                style: isUrdu
                    ? AppTextStyles.urduHeading(fontSize: 26)
                    : AppTextStyles.headingLarge.copyWith(color: AppColors.primaryBrand),
              ),
              const SizedBox(height: 6),
              Text(
                isUrdu
                    ? 'اسمارٹ فون، واٹس ایپ اور ویڈیو کال کے آسان اسباق۔'
                    : 'Simple lessons for smartphone, WhatsApp, and family video calls.',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // CATEGORIES GRID / LIST
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final cat = categories[i];

                  return AccessibleCard(
                    padding: const EdgeInsets.all(18),
                    onTap: () => _openCategoryDialog(context, cat, isUrdu, ref),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryTeal,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(cat.icon, color: AppColors.primaryBrand, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    cat.name,
                                    style: AppTextStyles.cardHeading.copyWith(fontSize: 17),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      '(${cat.nameUrdu})',
                                      style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isUrdu ? cat.descriptionUrdu : cat.description,
                                style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.menu_book_rounded, size: 16, color: AppColors.primaryBrand),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${cat.lessons.length} bite-sized lesson${cat.lessons.length > 1 ? "s" : ""}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryBrand),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 14),
                          child: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  void _openCategoryDialog(BuildContext context, LearningCategory cat, bool isUrdu, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollCtrl) => ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(22),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(cat.icon, color: AppColors.primaryBrand, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isUrdu ? cat.nameUrdu : cat.name,
                    style: AppTextStyles.headingMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(isUrdu ? cat.descriptionUrdu : cat.description, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 18),
            const Divider(color: AppColors.border),
            const SizedBox(height: 10),

            ...cat.lessons.map((lesson) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AccessibleCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showLessonReader(context, lesson, isUrdu, ref);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isUrdu ? lesson.titleUrdu : lesson.title, style: AppTextStyles.cardHeading),
                      const SizedBox(height: 4),
                      Text(
                        isUrdu ? lesson.explanationUrdu : lesson.explanation,
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Text('Tap to read steps & quiz', style: TextStyle(color: AppColors.primaryBrand, fontWeight: FontWeight.bold, fontSize: 13)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primaryBrand),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showLessonReader(BuildContext context, GeneralLesson lesson, bool isUrdu, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollCtrl) => ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(22),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            Text(isUrdu ? lesson.titleUrdu : lesson.title, style: AppTextStyles.headingLarge.copyWith(fontSize: 22)),
            const SizedBox(height: 12),
            Text(isUrdu ? lesson.explanationUrdu : lesson.explanation, style: AppTextStyles.bodyLarge),
            const SizedBox(height: 18),
            const Text('Action Steps:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 10),
            ...(isUrdu ? lesson.stepsUrdu : lesson.steps).asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: AppColors.secondaryTeal, shape: BoxShape.circle),
                      child: Text('${entry.key + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBrand)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(entry.value, style: AppTextStyles.bodyLarge.copyWith(fontSize: 16))),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_rounded, color: AppColors.success),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isUrdu ? lesson.safetyTipUrdu : lesson.safetyTip,
                      style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrand,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                ref.read(userProfileProvider.notifier).recordLessonCompletion(lesson.id, 100, wasIndependent: true);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lesson completed! Badge unlocked in My Progress.')),
                );
              },
              child: const Text('Mark as Completed', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
