import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_button.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../core/widgets/tech_saathi_logo.dart';
import '../../../data/repositories/app_providers.dart';

/// 5-Step Welcoming Onboarding Flow for older adults and digital beginners.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();

  int _currentPage = 0;
  String _selectedLang = 'ur-roman';
  String _selectedExperience = 'new';
  String _selectedLearningStyle = 'both';

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    final notifier = ref.read(userProfileProvider.notifier);
    await notifier.updateLanguage(_selectedLang);
    await notifier.updateExperienceLevel(_selectedExperience);
    await notifier.updateLearningStyle(_selectedLearningStyle);
    await notifier.completeOnboarding(_nameController.text);

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 28),
                tooltip: 'Go back to previous question',
                onPressed: _previousPage,
              )
            : null,
        title: const TechSaathiLogo(size: 38, showText: true),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Step ${_currentPage + 1} of 5',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Bar
            LinearProgressIndicator(
              value: (_currentPage + 1) / 5,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBrand),
              minHeight: 6,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Controlled stepped navigation
                onPageChanged: (idx) {
                  setState(() {
                    _currentPage = idx;
                  });
                },
                children: [
                  _buildScreen1Welcome(),
                  _buildScreen2Language(),
                  _buildScreen3Experience(),
                  _buildScreen4LearningStyle(),
                  _buildScreen5Completion(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: WELCOME
  Widget _buildScreen1Welcome() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.secondaryTeal,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryBrand.withOpacity(0.2), width: 3),
            ),
            child: const Icon(
              Icons.phone_iphone_rounded,
              size: 76,
              color: AppColors.primaryBrand,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to TechSaathi!',
            style: AppTextStyles.headingLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Your friendly guide to understanding technology.',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Technology Made Simple. Independence Made Possible.',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          AccessibleButton(
            label: 'Get Started',
            icon: Icons.arrow_forward_rounded,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  // SCREEN 2: LANGUAGE
  Widget _buildScreen2Language() {
    final options = [
      {'code': 'ur', 'label': 'اردو (Urdu)', 'sub': 'اردو زبان میں پڑھیں اور سنیں'},
      {'code': 'ur-roman', 'label': 'Roman Urdu', 'sub': 'Urdu written in English alphabets'},
      {'code': 'en', 'label': 'English', 'sub': 'Simple and friendly English'},
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Which language do you prefer?',
            style: AppTextStyles.headingLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'آپ کس زبان میں سیکھنا پسند کریں گے؟',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 24),
          ...options.map((opt) {
            final isSelected = _selectedLang == opt['code'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: AccessibleCard(
                borderColor: isSelected ? AppColors.primaryBrand : AppColors.border,
                backgroundColor: isSelected ? AppColors.secondaryTeal.withOpacity(0.4) : Colors.white,
                onTap: () {
                  setState(() {
                    _selectedLang = opt['code']!;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                      color: isSelected ? AppColors.primaryBrand : AppColors.secondaryText,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opt['label']!,
                            style: AppTextStyles.cardHeading.copyWith(
                              color: isSelected ? AppColors.primaryBrand : AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            opt['sub']!,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const Spacer(),
          AccessibleButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  // SCREEN 3: EXPERIENCE
  Widget _buildScreen3Experience() {
    final options = [
      {
        'key': 'new',
        'title': 'I am completely new.',
        'desc': 'I feel nervous and need gentle step-by-step guidance.',
        'icon': Icons.sentiment_satisfied_rounded,
      },
      {
        'key': 'little',
        'title': 'I know a little.',
        'desc': 'I can make calls but struggle with banking and apps.',
        'icon': Icons.touch_app_rounded,
      },
      {
        'key': 'basic',
        'title': 'I can use basic applications.',
        'desc': 'I use WhatsApp and want to become independent in banking.',
        'icon': Icons.thumb_up_rounded,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How comfortable are you with technology?',
            style: AppTextStyles.headingLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'There are no wrong answers — we match your comfortable pace.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 24),
          ...options.map((opt) {
            final isSelected = _selectedExperience == opt['key'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: AccessibleCard(
                borderColor: isSelected ? AppColors.primaryBrand : AppColors.border,
                backgroundColor: isSelected ? AppColors.secondaryTeal.withOpacity(0.4) : Colors.white,
                onTap: () {
                  setState(() {
                    _selectedExperience = opt['key'] as String;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      opt['icon'] as IconData,
                      color: isSelected ? AppColors.primaryBrand : AppColors.secondaryText,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opt['title'] as String,
                            style: AppTextStyles.cardHeading.copyWith(
                              color: isSelected ? AppColors.primaryBrand : AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            opt['desc'] as String,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const Spacer(),
          AccessibleButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  // SCREEN 4: LEARNING STYLE
  Widget _buildScreen4LearningStyle() {
    final styles = [
      {
        'key': 'both',
        'title': 'Both Voice and Text (Recommended)',
        'desc': 'Read clear instructions and listen to spoken voice guidance.',
        'icon': Icons.record_voice_over_rounded,
      },
      {
        'key': 'voice',
        'title': 'Voice Explanations',
        'desc': 'Listen to friendly spoken answers like talking to a teacher.',
        'icon': Icons.volume_up_rounded,
      },
      {
        'key': 'text',
        'title': 'Step-by-step Text',
        'desc': 'Read large, high-contrast instructions at your own pace.',
        'icon': Icons.menu_book_rounded,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How would you like us to teach you?',
            style: AppTextStyles.headingLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'You can always change this later in Settings.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 24),
          ...styles.map((st) {
            final isSelected = _selectedLearningStyle == st['key'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: AccessibleCard(
                borderColor: isSelected ? AppColors.primaryBrand : AppColors.border,
                backgroundColor: isSelected ? AppColors.secondaryTeal.withOpacity(0.4) : Colors.white,
                onTap: () {
                  setState(() {
                    _selectedLearningStyle = st['key'] as String;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      st['icon'] as IconData,
                      color: isSelected ? AppColors.primaryBrand : AppColors.secondaryText,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            st['title'] as String,
                            style: AppTextStyles.cardHeading.copyWith(
                              color: isSelected ? AppColors.primaryBrand : AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            st['desc'] as String,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const Spacer(),
          AccessibleButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  // SCREEN 5: COMPLETION
  Widget _buildScreen5Completion() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              color: AppColors.secondaryTeal,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration_rounded,
              size: 58,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Let's learn something new!",
            style: AppTextStyles.headingLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'What should TechSaathi call you?',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            style: AppTextStyles.bodyLarge,
            decoration: const InputDecoration(
              hintText: 'Enter your name (e.g., Uncle Aslam, Ammi, Tariq)',
              prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primaryBrand),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'TechSaathi is ready to help you learn safely without fear.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          AccessibleButton(
            label: 'Start Learning',
            icon: Icons.play_arrow_rounded,
            onPressed: _finishOnboarding,
          ),
        ],
      ),
    );
  }
}
