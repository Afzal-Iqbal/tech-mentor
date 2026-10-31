import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/app_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// TechSaathi AI Root Application.
class TechSaathiApp extends ConsumerWidget {
  const TechSaathiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final profile = ref.watch(userProfileProvider);
    final isUrdu = profile.preferredLanguage == 'ur';

    return MaterialApp.router(
      title: 'TechSaathi AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      locale: isUrdu ? const Locale('ur', 'PK') : const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ur', 'PK'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
