import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/practice_transaction.dart';

/// Local storage service managing offline persistence and user progress.
class StorageService {
  static const String _keyProfile = 'techsaathi_user_profile';
  static const String _keyTransactions = 'techsaathi_practice_transactions';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  /// Retrieve stored profile or default guest profile
  UserProfile getProfile() {
    final raw = _prefs.getString(_keyProfile);
    if (raw == null || raw.isEmpty) {
      return UserProfile.defaultUser();
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile.fromMap(map);
    } catch (_) {
      return UserProfile.defaultUser();
    }
  }

  /// Save updated user profile
  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(_keyProfile, jsonEncode(profile.toMap()));
  }

  /// Get list of simulated transactions for Demo Bank
  List<PracticeTransaction> getTransactions() {
    final rawList = _prefs.getStringList(_keyTransactions);
    if (rawList == null || rawList.isEmpty) {
      return _defaultSeedTransactions;
    }
    try {
      return rawList
          .map((item) => PracticeTransaction.fromMap(jsonDecode(item) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _defaultSeedTransactions;
    }
  }

  /// Add new simulated transaction and deduct/update balance
  Future<void> addTransaction(PracticeTransaction tx) async {
    final current = getTransactions();
    final updated = [tx, ...current];
    final encoded = updated.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList(_keyTransactions, encoded);

    // Update demo account balance
    final profile = getProfile();
    final newBalance = profile.demoAccountBalance - tx.amount;
    final newPracticeCount = profile.practiceCompleted + 1;
    final newIndependent = tx.wasIndependent
        ? profile.independentTasksCount + 1
        : profile.independentTasksCount;

    await saveProfile(profile.copyWith(
      demoAccountBalance: newBalance > 0 ? newBalance : 0.0,
      practiceCompleted: newPracticeCount,
      independentTasksCount: newIndependent,
    ));
  }

  /// Mark a lesson completed and save quiz score
  Future<void> markLessonCompleted(String lessonId, int score, {bool wasIndependent = false}) async {
    final profile = getProfile();
    final updatedCompleted = Set<String>.from(profile.completedLessonIds)..add(lessonId);
    final updatedScores = Map<String, int>.from(profile.quizScores)..[lessonId] = score;
    final newIndependent = wasIndependent
        ? profile.independentTasksCount + 1
        : profile.independentTasksCount;

    await saveProfile(profile.copyWith(
      completedLessonIds: updatedCompleted,
      lessonsCompleted: updatedCompleted.length,
      quizScores: updatedScores,
      independentTasksCount: newIndependent,
      learningStreak: profile.learningStreak + (updatedCompleted.length % 2 == 0 ? 1 : 0),
    ));
  }

  /// Clear all data for logout or fresh testing
  Future<void> clearAll() async {
    await _prefs.remove(_keyProfile);
    await _prefs.remove(_keyTransactions);
  }

  static final List<PracticeTransaction> _defaultSeedTransactions = [
    PracticeTransaction(
      id: 'tx_seed_1',
      recipientName: 'Initial Account Setup',
      accountNumber: 'PK00TECH00001234567890',
      bankName: 'TechSaathi Demo Bank',
      amount: 50000.0,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: 'Credit (Opening Balance)',
      status: 'Completed (Simulated)',
      referenceNumber: 'TS-SIM-001092',
      note: 'Simulated welcome deposit for learning practice',
      wasIndependent: true,
    ),
  ];
}
