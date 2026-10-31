/// Risk assessment categories for ScamShield
enum ScamRiskLevel {
  low,
  suspicious,
  highRisk;

  String get labelEn {
    switch (this) {
      case ScamRiskLevel.low:
        return 'Low Indicators';
      case ScamRiskLevel.suspicious:
        return 'Suspicious';
      case ScamRiskLevel.highRisk:
        return 'High Risk';
    }
  }

  String get labelUrdu {
    switch (this) {
      case ScamRiskLevel.low:
        return 'کم خطرہ / احتیاط جاری رکھیں';
      case ScamRiskLevel.suspicious:
        return 'مشکوک پیغام';
      case ScamRiskLevel.highRisk:
        return 'انتہائی خطرناک فراڈ';
    }
  }
}

/// ScamShield analysis outcome.
class ScamAnalysisResult {
  final ScamRiskLevel riskLevel;
  final List<String> warningSigns;
  final List<String> warningSignsUrdu;
  final String explanation;
  final String explanationUrdu;
  final String recommendedAction;
  final String recommendedActionUrdu;
  final List<String> detectedIndicators;

  const ScamAnalysisResult({
    required this.riskLevel,
    required this.warningSigns,
    required this.warningSignsUrdu,
    required this.explanation,
    required this.explanationUrdu,
    required this.recommendedAction,
    required this.recommendedActionUrdu,
    required this.detectedIndicators,
  });
}
