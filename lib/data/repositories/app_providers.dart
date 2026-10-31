import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/speech_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/tts_service.dart';
import '../models/banking_lesson.dart';
import '../models/learning_lesson.dart';
import '../models/practice_transaction.dart';
import '../models/user_profile.dart';
import '../../core/constants/banking_curriculum.dart';
import '../../core/constants/general_curriculum.dart';

/// Overridden at app startup in main.dart with initialized StorageService instance.
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be initialized before runApp');
});

final speechServiceProvider = Provider<SpeechService>((ref) {
  return SpeechService();
});

final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService();
});

final aiServiceProvider = Provider<AiService>((ref) {
  return AiService();
});

/// User Profile State Notifier
class UserProfileNotifier extends StateNotifier<UserProfile> {
  final StorageService _storageService;

  UserProfileNotifier(this._storageService) : super(_storageService.getProfile());

  Future<void> updateLanguage(String langCode) async {
    state = state.copyWith(preferredLanguage: langCode);
    await _storageService.saveProfile(state);
  }

  Future<void> updateExperienceLevel(String level) async {
    state = state.copyWith(experienceLevel: level);
    await _storageService.saveProfile(state);
  }

  Future<void> updateLearningStyle(String style) async {
    state = state.copyWith(learningStyle: style);
    await _storageService.saveProfile(state);
  }

  Future<void> completeOnboarding(String name) async {
    state = state.copyWith(name: name.trim().isEmpty ? 'Friend' : name.trim(), isOnboarded: true);
    await _storageService.saveProfile(state);
  }

  Future<void> recordLessonCompletion(String lessonId, int score, {bool wasIndependent = false}) async {
    await _storageService.markLessonCompleted(lessonId, score, wasIndependent: wasIndependent);
    state = _storageService.getProfile();
  }

  Future<void> updateDemoBalance(double balance) async {
    state = state.copyWith(demoAccountBalance: balance);
    await _storageService.saveProfile(state);
  }

  void syncProfile() {
    state = _storageService.getProfile();
  }

  Future<void> resetAll() async {
    await _storageService.clearAll();
    state = UserProfile.defaultUser();
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return UserProfileNotifier(storage);
});

/// Practice Lab Simulated Transactions State Notifier
class PracticeTransactionsNotifier extends StateNotifier<List<PracticeTransaction>> {
  final StorageService _storageService;
  final Ref _ref;

  PracticeTransactionsNotifier(this._storageService, this._ref)
      : super(_storageService.getTransactions());

  Future<void> makeTransfer({
    required String recipientName,
    required String accountNumber,
    required String bankName,
    required double amount,
    required String type,
    String note = '',
    bool wasIndependent = false,
  }) async {
    final tx = PracticeTransaction(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      recipientName: recipientName,
      accountNumber: accountNumber,
      bankName: bankName,
      amount: amount,
      timestamp: DateTime.now(),
      type: type,
      status: 'Completed (Simulated)',
      referenceNumber: 'TS-SIM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      note: note,
      wasIndependent: wasIndependent,
    );

    await _storageService.addTransaction(tx);
    state = _storageService.getTransactions();
    // Refresh user profile state to reflect updated balance & practice counts
    _ref.read(userProfileProvider.notifier).syncProfile();
  }

  void refresh() {
    state = _storageService.getTransactions();
  }
}

final practiceTransactionsProvider =
    StateNotifierProvider<PracticeTransactionsNotifier, List<PracticeTransaction>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return PracticeTransactionsNotifier(storage, ref);
});

/// Banking Saathi Curriculum Provider
final bankingLessonsProvider = Provider<List<BankingLesson>>((ref) {
  return BankingCurriculum.lessons;
});

/// General Learning Curriculum Provider
final generalCurriculumProvider = Provider<List<LearningCategory>>((ref) {
  return GeneralCurriculum.categories;
});
