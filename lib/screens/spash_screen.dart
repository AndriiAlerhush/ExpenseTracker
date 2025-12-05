import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/providers/auth_state_provider.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/auth_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends ConsumerState<SplashScreen> {
  bool _minDurationPassed = false;
  static const Duration _minimumDuration = Duration(
    seconds: 4,
  );

  @override
  void initState() {
    super.initState();

    Future.delayed(_minimumDuration, () {
      if (mounted) {
        setState(() {
          _minDurationPassed = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authStream = ref.watch(authStateProvider);

    if (!_minDurationPassed || authStream.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 250,
                height: 250,
              ),
              SizedBox(height: 60),
              CircularProgressIndicator(strokeWidth: 2),
            ],
          ),
        ),
      );
    }

    return authStream.whenData(
          (user) {
            if (user != null) {
              return const HomeScreen(key: ValueKey('Home'));
            } else {
              return const AuthScreen(key: ValueKey('Auth'));
            }
          },
        ).value ??
        const AuthScreen(key: ValueKey('Auth'));
  }
}
