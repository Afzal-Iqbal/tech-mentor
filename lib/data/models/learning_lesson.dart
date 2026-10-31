import 'package:flutter/material.dart';

/// General digital literacy lesson category.
class LearningCategory {
  final String id;
  final String name;
  final String nameUrdu;
  final String nameRomanUrdu;
  final String description;
  final String descriptionUrdu;
  final IconData icon;
  final List<GeneralLesson> lessons;

  const LearningCategory({
    required this.id,
    required this.name,
    required this.nameUrdu,
    required this.nameRomanUrdu,
    required this.description,
    required this.descriptionUrdu,
    required this.icon,
    required this.lessons,
  });
}

/// A micro-lesson within a general digital literacy category.
class GeneralLesson {
  final String id;
  final String categoryId;
  final String title;
  final String titleUrdu;
  final String explanation;
  final String explanationUrdu;
  final List<String> steps;
  final List<String> stepsUrdu;
  final String safetyTip;
  final String safetyTipUrdu;
  final String quizQuestion;
  final String quizQuestionUrdu;
  final List<String> quizOptions;
  final List<String> quizOptionsUrdu;
  final int correctIndex;

  const GeneralLesson({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.titleUrdu,
    required this.explanation,
    required this.explanationUrdu,
    required this.steps,
    required this.stepsUrdu,
    required this.safetyTip,
    required this.safetyTipUrdu,
    required this.quizQuestion,
    required this.quizQuestionUrdu,
    required this.quizOptions,
    required this.quizOptionsUrdu,
    required this.correctIndex,
  });
}
