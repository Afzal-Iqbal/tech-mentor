import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Future initialization: Firebase.initializeApp() and speech services
  runApp(
    const ProviderScope(
      child: TechSaathiApp(),
    ),
  );
}
