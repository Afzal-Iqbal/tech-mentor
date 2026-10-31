import 'package:flutter_test/flutter_test.dart';
import 'package:tech_saathi_ai/app/theme/app_colors.dart';
import 'package:tech_saathi_ai/core/constants/banking_curriculum.dart';
import 'package:tech_saathi_ai/core/constants/general_curriculum.dart';
import 'package:tech_saathi_ai/core/services/ai_service.dart';
import 'package:tech_saathi_ai/data/models/scam_analysis_result.dart';
import 'package:tech_saathi_ai/data/models/user_profile.dart';

void main() {
  test('AppColors design system tokens test', () {
    expect(AppColors.primaryBrand.value, 0xFF168C83);
    expect(AppColors.primaryBackground.value, 0xFFF8FAF9);
    expect(AppColors.primaryText.value, 0xFF24332F);
    expect(AppColors.secondaryTeal.value, 0xFFDDF3EF);
    expect(AppColors.success.value, 0xFF238B61);
    expect(AppColors.warning.value, 0xFFE5A23B);
    expect(AppColors.danger.value, 0xFFD9534F);
  });

  test('BankingCurriculum contains exactly 14 structured lessons', () {
    expect(BankingCurriculum.lessons.length, 14);
    for (int i = 0; i < 14; i++) {
      final lesson = BankingCurriculum.lessons[i];
      expect(lesson.order, i + 1);
      expect(lesson.title.isNotEmpty, true);
      expect(lesson.titleUrdu.isNotEmpty, true);
      expect(lesson.steps.isNotEmpty, true);
      expect(lesson.quizOptions.length, 3);
      expect(lesson.correctOptionIndex >= 0 && lesson.correctOptionIndex < 3, true);
    }
  });

  test('GeneralCurriculum contains core categories and micro-lessons', () {
    expect(GeneralCurriculum.categories.isNotEmpty, true);
    final whatsappCat = GeneralCurriculum.categories.firstWhere((c) => c.id == 'cat_whatsapp');
    expect(whatsappCat.lessons.isNotEmpty, true);
  });

  test('ScamShield detects high risk OTP phishing and prize scams', () async {
    final ai = AiService();
    final highRiskResult = await ai.analyzeSuspiciousMessage(
      'Congratulations! You won PKR 100,000 from BISP! Send your bank OTP code immediately or account blocked: http://fake.ly',
    );
    expect(highRiskResult.riskLevel, ScamRiskLevel.highRisk);
    expect(highRiskResult.warningSigns.isNotEmpty, true);

    final normalResult = await ai.analyzeSuspiciousMessage(
      'Assalam-o-Alaikum, please bring bread when coming home.',
    );
    expect(normalResult.riskLevel, ScamRiskLevel.low);
  });

  test('UserProfile model serialization and immutability', () {
    final user = UserProfile.defaultUser();
    expect(user.demoAccountBalance, 50000.0);
    expect(user.isOnboarded, false);

    final updated = user.copyWith(name: 'Ammi Jaan', isOnboarded: true, lessonsCompleted: 3);
    final map = updated.toMap();
    final restored = UserProfile.fromMap(map);

    expect(restored.name, 'Ammi Jaan');
    expect(restored.isOnboarded, true);
    expect(restored.lessonsCompleted, 3);
  });
}
