import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/app_router.dart';
import 'providers/app_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cardiotwin/firebase_options.dart';

// 1. Change this to 'Future<void> main() async'
Future<void> main() async {
  // 2. Add this line to ensure the Flutter engine is ready
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 3. Add the Firebase initialization
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const CardioTwinApp(),
    ),
  );
}

class CardioTwinApp extends StatelessWidget {
  const CardioTwinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardioTwin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Note: You may want to change AppRoutes.splash to a login route
      // if the user isn't authenticated yet.
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}