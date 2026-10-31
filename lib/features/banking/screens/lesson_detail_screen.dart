import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/constants/banking_curriculum.dart';
import '../../../core/widgets/accessible_button.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../data/models/banking_lesson.dart';
import '../../../data/repositories/app_providers.dart';

/// Detailed Lesson View with step-by-step illustrations and interactive quiz.
class LessonDetailScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  int? _selectedQuizIndex;
  bool _quizSubmitted = false;
  bool _isSpeaking = false;

  BankingLesson? _findLesson() {
    try {
      return BankingCurriculum.lessons.firstWhere((l) => l.id == widget.lessonId);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    ref.read(ttsServiceProvider).stop();
    super.dispose();
  }

  void _submitQuiz(BankingLesson lesson) {
    if (_selectedQuizIndex == null) return;

    final isCorrect = _selectedQuizIndex == lesson.correctOptionIndex;
    final score = isCorrect ? 100 : 50;

    setState(() {
      _quizSubmitted = true;
    });

    ref.read(userProfileProvider.notifier).recordLessonCompletion(
          lesson.id,
          score,
          wasIndependent: isCorrect,
        );
  }

  Future<void> _toggleListen(BankingLesson lesson) async {
    final tts = ref.read(ttsServiceProvider);
    final profile = ref.read(userProfileProvider);
    final isUrdu = profile.preferredLanguage == 'ur';

    if (_isSpeaking) {
      await tts.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      setState(() {
        _isSpeaking = true;
      });
      final readText = isUrdu
          ? '${lesson.titleUrdu}. ${lesson.meaningUrdu}. ${lesson.whyUsedUrdu}. اہم حفاظتی مشورہ: ${lesson.safetyAdviceUrdu}'
          : '${lesson.title}. ${lesson.meaning}. ${lesson.whyUsed}. Real life analogy: ${lesson.realLifeAnalogy}. Safety Advice: ${lesson.safetyAdvice}';

      await tts.speak(readText, languageCode: profile.preferredLanguage);
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = _findLesson();
    final profile = ref.watch(userProfileProvider);
    final isUrdu = profile.preferredLanguage == 'ur';

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: const Center(child: Text('Lesson not found.')),
      );
    }

    final isAlreadyCompleted = profile.completedLessonIds.contains(lesson.id);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: Text('Lesson ${lesson.order} of 14'),
        actions: [
          IconButton(
            icon: Icon(
              _isSpeaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
              color: AppColors.primaryBrand,
              size: 28,
            ),
            tooltip: _isSpeaking ? 'Stop voice' : 'Listen to this lesson',
            onPressed: () => _toggleListen(lesson),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lesson Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondaryTeal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'LESSON ${lesson.order}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: AppColors.primaryBrand,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isUrdu ? lesson.titleUrdu : lesson.title,
                style: isUrdu
                    ? AppTextStyles.urduHeading(fontSize: 26)
                    : AppTextStyles.headingLarge,
              ),
              if (!isUrdu) ...[
                const SizedBox(height: 4),
                Text(
                  lesson.titleUrdu,
                  style: const TextStyle(fontSize: 16, color: AppColors.secondaryText),
                ),
              ],
              const SizedBox(height: 18),

              // WHAT IT MEANS CARD
              AccessibleCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_rounded, color: AppColors.warning, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'What Does This Mean?',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isUrdu ? lesson.meaningUrdu : lesson.meaning,
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Icon(Icons.help_outline_rounded, color: AppColors.primaryBrand, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Why Is It Used?',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isUrdu ? lesson.whyUsedUrdu : lesson.whyUsed,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // REAL LIFE ANALOGY CARD
              AccessibleCard(
                backgroundColor: const Color(0xFFF0FDF4),
                borderColor: const Color(0xFFBBF7D0),
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.psychology_alt_rounded, color: AppColors.success, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Real-Life Analogy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isUrdu ? lesson.realLifeAnalogyUrdu : lesson.realLifeAnalogy,
                            style: const TextStyle(fontSize: 16, height: 1.4, color: AppColors.primaryText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // STEP BY STEP GUIDANCE
              Text(
                'Step-by-Step Actions',
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: 12),
              ...lesson.steps.map((step) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AccessibleCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryTeal,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${step.stepNumber}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primaryBrand,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isUrdu ? step.titleUrdu : step.title,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isUrdu ? step.descriptionUrdu : step.description,
                                style: AppTextStyles.bodyMedium.copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // COMMON MISTAKES
              AccessibleCard(
                backgroundColor: const Color(0xFFFEF2F2),
                borderColor: const Color(0xFFFECACA),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Common Mistakes to Avoid',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.danger),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...lesson.commonMistakes.map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppColors.danger, fontSize: 16, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                m,
                                style: const TextStyle(fontSize: 15, color: Color(0xFF991B1B)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // CRITICAL SAFETY ADVICE
              AccessibleCard(
                backgroundColor: AppColors.secondaryTeal.withOpacity(0.4),
                borderColor: AppColors.primaryBrand.withOpacity(0.4),
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_rounded, color: AppColors.primaryBrand, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Golden Safety Rule',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBrand,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isUrdu ? lesson.safetyAdviceUrdu : lesson.safetyAdvice,
                            style: const TextStyle(fontSize: 15, height: 1.4, color: AppColors.primaryText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // LET'S PRACTISE BUTTON
              AccessibleButton(
                label: "Let's Practise in Demo Bank",
                icon: Icons.biotech_rounded,
                type: AccessibleButtonType.secondary,
                onPressed: () => context.push('/practice-lab'),
              ),

              const SizedBox(height: 32),

              // INTERACTIVE QUIZ SECTION
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.quiz_rounded, color: AppColors.primaryBrand, size: 26),
                        const SizedBox(width: 10),
                        const Text(
                          'Quick Knowledge Quiz',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        if (isAlreadyCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryTeal,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Passed', style: TextStyle(color: AppColors.primaryBrand, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isUrdu ? lesson.quizQuestionUrdu : lesson.quizQuestion,
                      style: AppTextStyles.cardHeading.copyWith(fontSize: 17),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(lesson.quizOptions.length, (optIdx) {
                      final optionText = isUrdu ? lesson.quizOptionsUrdu[optIdx] : lesson.quizOptions[optIdx];
                      final isSelected = _selectedQuizIndex == optIdx;
                      final isCorrect = optIdx == lesson.correctOptionIndex;

                      Color cardBg = Colors.white;
                      Color borderColor = AppColors.border;

                      if (_quizSubmitted) {
                        if (isCorrect) {
                          cardBg = const Color(0xFFDCFCE7);
                          borderColor = AppColors.success;
                        } else if (isSelected && !isCorrect) {
                          cardBg = const Color(0xFFFEE2E2);
                          borderColor = AppColors.danger;
                        }
                      } else if (isSelected) {
                        cardBg = AppColors.secondaryTeal.withOpacity(0.5);
                        borderColor = AppColors.primaryBrand;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: _quizSubmitted
                              ? null
                              : () {
                                  setState(() {
                                    _selectedQuizIndex = optIdx;
                                  });
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor, width: 1.4),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? (_quizSubmitted && isCorrect
                                          ? Icons.check_circle_rounded
                                          : _quizSubmitted && !isCorrect
                                              ? Icons.cancel_rounded
                                              : Icons.check_circle_rounded)
                                      : Icons.radio_button_unchecked_rounded,
                                  color: borderColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 14),

                    if (!_quizSubmitted)
                      AccessibleButton(
                        label: 'Check My Answer',
                        onPressed: _selectedQuizIndex == null ? null : () => _submitQuiz(lesson),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _selectedQuizIndex == lesson.correctOptionIndex
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              _selectedQuizIndex == lesson.correctOptionIndex
                                  ? Icons.check_circle_rounded
                                  : Icons.info_outline_rounded,
                              color: _selectedQuizIndex == lesson.correctOptionIndex
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                isUrdu ? lesson.quizExplanationUrdu : lesson.quizExplanation,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
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
}
