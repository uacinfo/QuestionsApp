import 'dart:io';

import 'package:VetScholar/theme_provider.dart';
import 'package:VetScholar/pages/sign_up_page.dart';
import 'package:VetScholar/pages/signin_page.dart';
import 'package:VetScholar/pages/subject_list_page.dart';
import 'package:VetScholar/pages/test_history/test_history.dart';
import 'package:VetScholar/service/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'service/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnvFilesWithConflictHandling();
  bool isValid = false;
  try {
    if (await AuthService.getAccessToken() != null) {
      isValid = await ProfileService().whoami();
    }
  } on Exception {
    isValid = false;
  }
  runApp(ChangeNotifierProvider(
      create: (_) => ThemeProvider(), child: QuizApp(isLoggedIn: isValid)));
}

// This Function will overwrite the keys in environmentVars with keys in commonVars, if keys are same
Future<void> loadEnvFilesWithConflictHandling() async {
  await dotenv.load(fileName: const String.fromEnvironment("environmentVars"));
  final envSpecific = Map<String, String>.from(dotenv.env);
  await dotenv.load(fileName: const String.fromEnvironment("commonVars"));
  final commonEnv = Map<String, String>.from(dotenv.env);

  dotenv.env
    ..clear()
    ..addAll(commonEnv)
    ..addAll(envSpecific);
}

class QuizApp extends StatelessWidget {
  final bool isLoggedIn;

  const QuizApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          initialRoute: isLoggedIn
              ? dotenv.env['ROUTE_SUBJECTS']
              : dotenv.env['ROUTE_SIGN_IN'],
          routes: {
            '/signin': (context) => LoginPage(),
            '/subjects': (context) => SubjectListPage(),
            '/singup': (context) => SignupPage(),
            '/testHistory': (context) => const TestHistoryPage()
          },
        );
      },
    );
  }
}
