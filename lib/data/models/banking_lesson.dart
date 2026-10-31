import 'package:flutter/material.dart';

/// Single step within a lesson.
class LessonStep {
  final int stepNumber;
  final String title;
  final String titleUrdu;
  final String description;
  final String descriptionUrdu;
  final IconData? icon;

  const LessonStep({
    required this.stepNumber,
    required this.title,
    required this.titleUrdu,
    required this.description,
    required this.descriptionUrdu,
    this.icon,
  });
}

/// Banking Saathi interactive lesson model.
class BankingLesson {
  final String id;
  final int order;
  final String title;
  final String titleUrdu;
  final String titleRomanUrdu;
  final String summary;
  final String summaryUrdu;
  final String meaning;
  final String meaningUrdu;
  final String whyUsed;
  final String whyUsedUrdu;
  final String realLifeAnalogy;
  final String realLifeAnalogyUrdu;
  final List<LessonStep> steps;
  final List<String> commonMistakes;
  final List<String> commonMistakesUrdu;
  final String safetyAdvice;
  final String safetyAdviceUrdu;
  final String practicePrompt;
  final IconData icon;

  // Quiz
  final String quizQuestion;
  final String quizQuestionUrdu;
  final List<String> quizOptions;
  final List<String> quizOptionsUrdu;
  final int correctOptionIndex;
  final String quizExplanation;
  final String quizExplanationUrdu;

  const BankingLesson({
    required this.id,
    required this.order,
    required this.title,
    required this.titleUrdu,
    required this.titleRomanUrdu,
    required this.summary,
    required this.summaryUrdu,
    required this.meaning,
    required this.meaningUrdu,
    required this.whyUsed,
    required this.whyUsedUrdu,
    required this.realLifeAnalogy,
    required this.realLifeAnalogyUrdu,
    required this.steps,
    required this.commonMistakes,
    required this.commonMistakesUrdu,
    required this.safetyAdvice,
    required this.safetyAdviceUrdu,
    required this.practicePrompt,
    required this.icon,
    required this.quizQuestion,
    required this.quizQuestionUrdu,
    required this.quizOptions,
    required this.quizOptionsUrdu,
    required this.correctOptionIndex,
    required this.quizExplanation,
    required this.quizExplanationUrdu,
  });
}
