import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/services/storage_service.dart';
import 'data/repositories/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize offline-first local storage service
  final storageService = await StorageService.init();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const TechSaathiApp(),
    ),
  );
}
