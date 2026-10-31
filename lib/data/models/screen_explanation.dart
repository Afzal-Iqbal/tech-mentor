/// Single button explanation on a confusing screen.
class ButtonExplanation {
  final String buttonName;
  final String meaning;
  final String meaningUrdu;
  final bool isSafe;

  const ButtonExplanation({
    required this.buttonName,
    required this.meaning,
    required this.meaningUrdu,
    this.isSafe = true,
  });
}

/// Screen explainer AI result model.
class ScreenExplanationResult {
  final String screenName;
  final String screenNameUrdu;
  final String whatIsThisScreen;
  final String whatIsThisScreenUrdu;
  final List<ButtonExplanation> buttonMeanings;
  final String whatYouCanDo;
  final String whatYouCanDoUrdu;
  final String thingsToWatchOut;
  final String thingsToWatchOutUrdu;
  final String nextSafeStep;
  final String nextSafeStepUrdu;

  const ScreenExplanationResult({
    required this.screenName,
    required this.screenNameUrdu,
    required this.whatIsThisScreen,
    required this.whatIsThisScreenUrdu,
    required this.buttonMeanings,
    required this.whatYouCanDo,
    required this.whatYouCanDoUrdu,
    required this.thingsToWatchOut,
    required this.thingsToWatchOutUrdu,
    required this.nextSafeStep,
    required this.nextSafeStepUrdu,
  });
}
