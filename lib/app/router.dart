import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/services/storage_service.dart';
import '../features/ai_teacher/screens/ai_teacher_screen.dart';
import '../features/banking/screens/banking_saathi_screen.dart';
import '../features/banking/screens/lesson_detail_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/learning/screens/learning_screen.dart';
import '../features/main_navigation/screens/main_scaffold.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/practice_lab/screens/money_transfer_screen.dart';
import '../features/practice_lab/screens/practice_lab_home_screen.dart';
import '../features/practice_lab/screens/transaction_history_screen.dart';
import '../features/practice_lab/screens/transaction_review_screen.dart';
import '../features/practice_lab/screens/transaction_success_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/progress/screens/progress_screen.dart';
import '../features/scamshield/screens/scamshield_screen.dart';
import '../features/screen_explainer/screens/screen_explainer_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/app_providers.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Riverpod provider for GoRouter so navigation state is preserved across profile updates.
final appRouterProvider = Provider<GoRouter>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return createAppRouter(storageService);
});

/// Function to build GoRouter with initial route based on onboarding state.
GoRouter createAppRouter(StorageService storageService) {
  final initialOnboarded = storageService.getProfile().isOnboarded;

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialOnboarded ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // 4-Tab Stateful Shell Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // TAB 1: HOME
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // TAB 2: LEARN
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/learn',
                name: 'learn',
                builder: (context, state) => const LearningScreen(),
              ),
            ],
          ),

          // TAB 3: PRACTICE
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/practice-lab',
                name: 'practice_lab',
                builder: (context, state) => const PracticeLabHomeScreen(),
              ),
            ],
          ),

          // TAB 4: MY PROGRESS
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                name: 'progress',
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
        ],
      ),

      // FEATURE ROUTES ACCESSIBLE FROM ANYWHERE
      GoRoute(
        path: '/ai-teacher',
        name: 'ai_teacher',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final voiceParam = state.uri.queryParameters['voice'];
          return AiTeacherScreen(startWithVoice: voiceParam == 'true');
        },
      ),
      GoRoute(
        path: '/banking-saathi',
        name: 'banking_saathi',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const BankingSaathiScreen(),
        routes: [
          GoRoute(
            path: ':lessonId',
            name: 'lesson_detail',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final lessonId = state.pathParameters['lessonId'] ?? '';
              return LessonDetailScreen(lessonId: lessonId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/scamshield',
        name: 'scamshield',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ScamshieldScreen(),
      ),
      GoRoute(
        path: '/screen-explainer',
        name: 'screen_explainer',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ScreenExplainerScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),

      // PRACTICE LAB DETAIL WORKFLOW ROUTES
      GoRoute(
        path: '/practice-lab/transfer',
        name: 'practice_transfer',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final isBill = state.uri.queryParameters['bill'] == 'true';
          return MoneyTransferScreen(isBillPayment: isBill);
        },
      ),
      GoRoute(
        path: '/practice-lab/review',
        name: 'practice_review',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return TransactionReviewScreen(transactionData: data);
        },
      ),
      GoRoute(
        path: '/practice-lab/success',
        name: 'practice_success',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return TransactionSuccessScreen(transactionData: data);
        },
      ),
      GoRoute(
        path: '/practice-lab/history',
        name: 'practice_history',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const TransactionHistoryScreen(),
      ),
    ],
  );
}
