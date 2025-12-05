import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown';
    final email = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
    final id = FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 52),
          Stack(
            children: [
              CircleAvatar(
                radius: 72,
                child: const Icon(
                  Icons.person,
                  size: 80,
                ),
              ),
              Positioned(
                top: 98,
                right: 86,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                  },
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 24,
                    color: Colors.red,
                  ),
                ),
              ),
              Positioned(
                top: 98,
                left: 86,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                  },
                  child: const Icon(
                    Icons.add,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ListTile(
              leading: const Icon(Icons.person_pin_rounded, size: 36),
              title: const Text('Name'),
              subtitle: Text(name),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ListTile(
              leading: const Icon(Icons.email, size: 36),
              title: const Text('Email'),
              subtitle: Text(email),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ListTile(
              leading: const Icon(Icons.assignment, size: 36),
              title: const Text('ID'),
              subtitle: Text(id),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    HapticFeedback.lightImpact();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Delete",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    HapticFeedback.lightImpact();

                    final isSignedOut = await signOutUser();

                    if (!isSignedOut || !context.mounted) {
                      scaffoldMessengerKey.currentState?.showSnackBar(
                        const SnackBar(
                          content: Text('Error on signing out.'),
                        ),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).clearSnackBars();

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (ctx) => const AuthScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Log out",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Future<bool> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }
}
