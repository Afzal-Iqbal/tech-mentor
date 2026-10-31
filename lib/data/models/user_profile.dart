/// User Profile Model for TechSaathi AI.
class UserProfile {
  final String id;
  final String name;
  final String preferredLanguage; // 'en', 'ur', 'ur-roman'
  final String experienceLevel; // 'new', 'little', 'basic'
  final String learningStyle; // 'text', 'voice', 'both'
  final bool isOnboarded;
  final int lessonsCompleted;
  final int practiceCompleted;
  final int learningStreak;
  final int independentTasksCount;
  final Map<String, int> quizScores; // lessonId -> score (0-100)
  final Set<String> completedLessonIds;
  final double demoAccountBalance;

  const UserProfile({
    required this.id,
    required this.name,
    required this.preferredLanguage,
    required this.experienceLevel,
    required this.learningStyle,
    this.isOnboarded = false,
    this.lessonsCompleted = 0,
    this.practiceCompleted = 0,
    this.learningStreak = 1,
    this.independentTasksCount = 0,
    this.quizScores = const {},
    this.completedLessonIds = const {},
    this.demoAccountBalance = 50000.0,
  });

  factory UserProfile.defaultUser() {
    return const UserProfile(
      id: 'local_guest',
      name: 'Friend',
      preferredLanguage: 'ur-roman',
      experienceLevel: 'new',
      learningStyle: 'both',
      isOnboarded: false,
      lessonsCompleted: 0,
      practiceCompleted: 0,
      learningStreak: 1,
      independentTasksCount: 0,
      quizScores: {},
      completedLessonIds: {},
      demoAccountBalance: 50000.0,
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? preferredLanguage,
    String? experienceLevel,
    String? learningStyle,
    bool? isOnboarded,
    int? lessonsCompleted,
    int? practiceCompleted,
    int? learningStreak,
    int? independentTasksCount,
    Map<String, int>? quizScores,
    Set<String>? completedLessonIds,
    double? demoAccountBalance,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      learningStyle: learningStyle ?? this.learningStyle,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      practiceCompleted: practiceCompleted ?? this.practiceCompleted,
      learningStreak: learningStreak ?? this.learningStreak,
      independentTasksCount: independentTasksCount ?? this.independentTasksCount,
      quizScores: quizScores ?? this.quizScores,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      demoAccountBalance: demoAccountBalance ?? this.demoAccountBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'preferredLanguage': preferredLanguage,
      'experienceLevel': experienceLevel,
      'learningStyle': learningStyle,
      'isOnboarded': isOnboarded,
      'lessonsCompleted': lessonsCompleted,
      'practiceCompleted': practiceCompleted,
      'learningStreak': learningStreak,
      'independentTasksCount': independentTasksCount,
      'quizScores': quizScores,
      'completedLessonIds': completedLessonIds.toList(),
      'demoAccountBalance': demoAccountBalance,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String? ?? 'local_guest',
      name: map['name'] as String? ?? 'Friend',
      preferredLanguage: map['preferredLanguage'] as String? ?? 'ur-roman',
      experienceLevel: map['experienceLevel'] as String? ?? 'new',
      learningStyle: map['learningStyle'] as String? ?? 'both',
      isOnboarded: map['isOnboarded'] as bool? ?? false,
      lessonsCompleted: map['lessonsCompleted'] as int? ?? 0,
      practiceCompleted: map['practiceCompleted'] as int? ?? 0,
      learningStreak: map['learningStreak'] as int? ?? 1,
      independentTasksCount: map['independentTasksCount'] as int? ?? 0,
      quizScores: (map['quizScores'] as Map<dynamic, dynamic>?)?.map(
            (k, v) => MapEntry(k.toString(), v as int),
          ) ??
          {},
      completedLessonIds: (map['completedLessonIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toSet() ??
          {},
      demoAccountBalance: (map['demoAccountBalance'] as num?)?.toDouble() ?? 50000.0,
    );
  }
}
