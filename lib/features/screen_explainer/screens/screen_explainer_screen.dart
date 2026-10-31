import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_button.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../data/models/screen_explanation.dart';
import '../../../data/repositories/app_providers.dart';

/// Multimodal AI Screenshot Explainer Screen.
class ScreenExplainerScreen extends ConsumerStatefulWidget {
  const ScreenExplainerScreen({super.key});

  @override
  ConsumerState<ScreenExplainerScreen> createState() => _ScreenExplainerScreenState();
}

class _ScreenExplainerScreenState extends ConsumerState<ScreenExplainerScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes;
  String _selectedPresetType = 'bank_transfer';
  bool _isAnalyzing = false;
  ScreenExplanationResult? _explanationResult;

  final List<Map<String, String>> _sampleScreens = [
    {
      'type': 'bank_transfer',
      'label': 'Bank Transfer Review Screen',
      'sub': 'Shows recipient confirmation before sending money',
    },
    {
      'type': 'whatsapp_call',
      'label': 'WhatsApp Incoming Call Screen',
      'sub': 'Shows green and red buttons when someone calls',
    },
    {
      'type': 'otp_sms',
      'label': 'Bank OTP SMS Message',
      'sub': 'Shows one-time 6-digit verification code',
    },
  ];

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedPresetType = 'custom_upload';
        });
        await _analyzeScreen();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gallery selection cancelled or unavailable. You can use the sample screens below.')),
      );
    }
  }

  Future<void> _analyzeScreen() async {
    setState(() {
      _isAnalyzing = true;
      _explanationResult = null;
    });

    final ai = ref.read(aiServiceProvider);
    try {
      final result = await ai.explainScreenshot(
        imageBytes: _selectedImageBytes,
        screenType: _selectedPresetType,
      );
      if (mounted) {
        setState(() {
          _explanationResult = result;
          _isAnalyzing = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Explain My Screen', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Heading
              Text(
                "Don't Understand Your Screen?",
                style: AppTextStyles.headingLarge.copyWith(color: AppColors.primaryBrand),
              ),
              const SizedBox(height: 6),
              Text(
                'Let TechSaathi explain every button and field in simple words.',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 18),

              // MANDATORY PRIVACY REMINDER CARD
              const AccessibleCard(
                backgroundColor: Color(0xFFFFFBEB),
                borderColor: Color(0xFFFDE68A),
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.privacy_tip_rounded, color: AppColors.warning, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privacy Protection Rule',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF92400E)),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Please hide passwords, OTPs, PINs, account numbers and other sensitive information before uploading.',
                            style: TextStyle(fontSize: 14, color: Color(0xFF78350F), height: 1.35),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons: Pick Screenshot or Try Samples
              Row(
                children: [
                  Expanded(
                    child: AccessibleButton(
                      label: 'Select Screenshot',
                      icon: Icons.photo_library_rounded,
                      onPressed: _pickImageFromGallery,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Preset Sample Screens for Immediate Demo
              Text('Or Try A Sample Confusing Screen:', style: AppTextStyles.cardHeading),
              const SizedBox(height: 10),
              ..._sampleScreens.map((sample) {
                final isSelected = _selectedPresetType == sample['type'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AccessibleCard(
                    borderColor: isSelected ? AppColors.primaryBrand : AppColors.border,
                    backgroundColor: isSelected ? AppColors.secondaryTeal.withOpacity(0.4) : Colors.white,
                    onTap: () {
                      setState(() {
                        _selectedPresetType = sample['type']!;
                        _selectedImageBytes = null;
                      });
                      _analyzeScreen();
                    },
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle_rounded : Icons.phone_android_rounded,
                          color: isSelected ? AppColors.primaryBrand : AppColors.secondaryText,
                          size: 28,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sample['label']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? AppColors.primaryBrand : AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                sample['sub']!,
                                style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrand,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedPresetType = sample['type']!;
                              _selectedImageBytes = null;
                            });
                            _analyzeScreen();
                          },
                          child: const Text('Explain', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              if (_isAnalyzing)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(color: AppColors.primaryBrand),
                        const SizedBox(height: 16),
                        Text(
                          'TechSaathi is examining the screen for you...',
                          style: AppTextStyles.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),

              // STRUCTURED AI BREAKDOWN RESULTS
              if (_explanationResult != null && !_isAnalyzing) ...[
                const Divider(height: 32, color: AppColors.border),
                Text(
                  'Screen Breakdown & Safe Guide',
                  style: AppTextStyles.headingMedium,
                ),
                const SizedBox(height: 14),

                // 1. WHAT IS THIS SCREEN?
                _buildSectionCard(
                  number: '1',
                  title: 'What is this screen?',
                  icon: Icons.info_outline_rounded,
                  iconColor: AppColors.primaryBrand,
                  content: _explanationResult!.whatIsThisScreen,
                  urduContent: _explanationResult!.whatIsThisScreenUrdu,
                ),
                const SizedBox(height: 12),

                // 2. BUTTON MEANINGS
                AccessibleCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.touch_app_rounded, color: AppColors.primaryBrand, size: 24),
                          SizedBox(width: 10),
                          Text(
                            '2. What do the important buttons mean?',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._explanationResult!.buttonMeanings.map(
                        (b) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryTeal.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.radio_button_checked, size: 16, color: AppColors.primaryBrand),
                                    const SizedBox(width: 8),
                                    Text(
                                      b.buttonName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(b.meaning, style: const TextStyle(fontSize: 15, color: AppColors.primaryText)),
                                const SizedBox(height: 2),
                                Text(b.meaningUrdu, style: const TextStyle(fontSize: 14, color: AppColors.secondaryText)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 3. WHAT YOU CAN DO
                _buildSectionCard(
                  number: '3',
                  title: 'What can you do here?',
                  icon: Icons.task_alt_rounded,
                  iconColor: AppColors.success,
                  content: _explanationResult!.whatYouCanDo,
                  urduContent: _explanationResult!.whatYouCanDoUrdu,
                ),
                const SizedBox(height: 12),

                // 4. THINGS TO WATCH OUT FOR
                _buildSectionCard(
                  number: '4',
                  title: 'What should you be careful about?',
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppColors.danger,
                  content: _explanationResult!.thingsToWatchOut,
                  urduContent: _explanationResult!.thingsToWatchOutUrdu,
                  bgColor: const Color(0xFFFEF2F2),
                  borderColor: const Color(0xFFFECACA),
                ),
                const SizedBox(height: 12),

                // 5. NEXT SAFE STEP
                _buildSectionCard(
                  number: '5',
                  title: 'The single safest next step',
                  icon: Icons.shield_rounded,
                  iconColor: AppColors.primaryBrand,
                  content: _explanationResult!.nextSafeStep,
                  urduContent: _explanationResult!.nextSafeStepUrdu,
                  bgColor: const Color(0xFFF0FDF4),
                  borderColor: const Color(0xFFBBF7D0),
                ),
                const SizedBox(height: 36),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String number,
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
    required String urduContent,
    Color? bgColor,
    Color? borderColor,
  }) {
    return AccessibleCard(
      backgroundColor: bgColor ?? Colors.white,
      borderColor: borderColor ?? AppColors.border,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$number. $title',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(content, style: const TextStyle(fontSize: 16, height: 1.4, color: AppColors.primaryText)),
          const SizedBox(height: 6),
          Text(urduContent, style: const TextStyle(fontSize: 15, height: 1.4, color: AppColors.secondaryText)),
        ],
      ),
    );
  }
}
