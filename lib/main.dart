import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:expense_tracker/firebase_options.dart';

import 'package:expense_tracker/screens/spash_screen.dart';
import 'package:expense_tracker/providers/auth_state_provider.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      ProviderScope(
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStream = ref.watch(authStateProvider);

    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.blueGrey,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.blueGrey,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color.fromARGB(255, 37, 43, 45),
          contentTextStyle: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
      themeMode: ThemeMode.system,

      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      home: authStream.when(
        data: (user) => const SplashScreen(),
        loading: () => const SplashScreen(),
        error: (error, stackTrace) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  const Text('Fatal Error'),
                  TextButton(
                    onPressed: () {
                      SystemChannels.platform.invokeMethod(
                        'SystemNavigator.pop',
                      );
                    },
                    child: const Text('Close App'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
