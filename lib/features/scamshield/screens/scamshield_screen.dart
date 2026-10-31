import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../data/models/scam_analysis_result.dart';
import '../../../data/repositories/app_providers.dart';

/// ScamShield: Threat, Scam & Fraud Detection Scanner.
class ScamshieldScreen extends ConsumerStatefulWidget {
  const ScamshieldScreen({super.key});

  @override
  ConsumerState<ScamshieldScreen> createState() => _ScamshieldScreenState();
}

class _ScamshieldScreenState extends ConsumerState<ScamshieldScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isAnalyzing = false;
  ScamAnalysisResult? _result;

  final List<Map<String, String>> _sampleMessages = [
    {
      'title': 'Fake BISP / Lottery SMS',
      'text': 'Mubarak ho! Aap ka BISP Ehsaas program se 50,000 rupay ka inaam nikla hai. Fauran call karein 0301-2345678.',
    },
    {
      'title': 'Urgent Bank Block Threat',
      'text': 'Urgent Alert: Your bank account will be blocked in 10 minutes. Send your 6-digit OTP code to verify immediately: http://bit.ly/bank-fake',
    },
    {
      'title': 'Normal Family Message',
      'text': 'Assalam-o-Alaikum Ammi, main shaam ko 6 bajay ghar aaoonga aur fal le kar aaoonga.',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _analyze(String text) async {
    final query = text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste or type a message first')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _result = null;
    });

    final ai = ref.read(aiServiceProvider);
    try {
      final res = await ai.analyzeSuspiciousMessage(query);
      if (mounted) {
        setState(() {
          _result = res;
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
        title: const Text('ScamShield', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Not Sure If A Message Is Real?',
                style: AppTextStyles.headingLarge.copyWith(color: AppColors.primaryBrand),
              ),
              const SizedBox(height: 6),
              Text(
                'Paste any suspicious SMS, WhatsApp forward, or link below to scan for fraud tactics.',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 18),

              // Text Area for Message
              AccessibleCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _messageController,
                      maxLines: 4,
                      style: AppTextStyles.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: 'Paste suspicious message text or link here...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                    const Divider(color: AppColors.border),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.clear_rounded, size: 20, color: AppColors.secondaryText),
                          label: const Text('Clear', style: TextStyle(color: AppColors.secondaryText)),
                          onPressed: () {
                            _messageController.clear();
                            setState(() {
                              _result = null;
                            });
                          },
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrand,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.security_rounded, size: 20),
                          label: const Text('Scan Message', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          onPressed: () => _analyze(_messageController.text),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Quick Try Samples
              Text('Or Try A Common Scam Sample:', style: AppTextStyles.cardHeading),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _sampleMessages.map((sample) {
                  return ActionChip(
                    backgroundColor: AppColors.secondaryTeal,
                    side: const BorderSide(color: AppColors.border),
                    avatar: const Icon(Icons.sms_failed_rounded, size: 18, color: AppColors.primaryBrand),
                    label: Text(
                      sample['title']!,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryBrand),
                    ),
                    onPressed: () {
                      _messageController.text = sample['text']!;
                      _analyze(sample['text']!);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              if (_isAnalyzing)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(color: AppColors.primaryBrand),
                        const SizedBox(height: 14),
                        Text(
                          'ScamShield is analyzing psychological triggers and fraud patterns...',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

              // RESULT CARD
              if (_result != null && !_isAnalyzing) ...[
                const Divider(height: 32, color: AppColors.border),
                _buildAnalysisResultCard(_result!),
              ],

              const SizedBox(height: 28),

              // Permanent Safety Notice
              AccessibleCard(
                backgroundColor: AppColors.secondaryTeal.withOpacity(0.3),
                padding: const EdgeInsets.all(16),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.primaryBrand, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Golden Rule: Real banks never ask for passwords on calls or SMS. When in doubt, call the official helpline on the back of your card.',
                        style: TextStyle(fontSize: 14, height: 1.35, color: AppColors.primaryText),
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

  Widget _buildAnalysisResultCard(ScamAnalysisResult result) {
    Color badgeBg;
    Color badgeFg;
    IconData badgeIcon;

    switch (result.riskLevel) {
      case ScamRiskLevel.highRisk:
        badgeBg = const Color(0xFFFEE2E2);
        badgeFg = AppColors.danger;
        badgeIcon = Icons.dangerous_rounded;
        break;
      case ScamRiskLevel.suspicious:
        badgeBg = const Color(0xFFFEF3C7);
        badgeFg = AppColors.warning;
        badgeIcon = Icons.warning_rounded;
        break;
      case ScamRiskLevel.low:
        badgeBg = const Color(0xFFDCFCE7);
        badgeFg = AppColors.success;
        badgeIcon = Icons.check_circle_rounded;
        break;
    }

    return AccessibleCard(
      padding: const EdgeInsets.all(20),
      borderColor: badgeFg.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RISK BADGE
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: badgeFg.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(badgeIcon, color: badgeFg, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Risk Level: ${result.riskLevel.labelEn}',
                      style: TextStyle(
                        color: badgeFg,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            result.riskLevel.labelUrdu,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 16),

          // EXPLANATION
          Text(
            'Explanation:',
            style: AppTextStyles.cardHeading.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            result.explanation,
            style: AppTextStyles.bodyLarge.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            result.explanationUrdu,
            style: const TextStyle(fontSize: 15, color: AppColors.secondaryText, height: 1.4),
          ),
          const SizedBox(height: 18),

          // WARNING SIGNS
          Text(
            'Warning Signs Identified:',
            style: AppTextStyles.cardHeading.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...result.warningSigns.map(
            (sign) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🚨 ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      sign,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.primaryText),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // RECOMMENDED ACTION
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.directions_run_rounded, color: AppColors.primaryBrand, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Recommended Action:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryBrand),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  result.recommendedAction,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primaryText),
                ),
                const SizedBox(height: 4),
                Text(
                  result.recommendedActionUrdu,
                  style: const TextStyle(fontSize: 14, color: AppColors.secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
