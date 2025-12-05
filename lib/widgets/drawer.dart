import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/user_profile_screen.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            color: Colors.blueGrey,
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const UserProfileScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: const Icon(
                        Icons.person,
                        size: 36,
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text(
                          'Andrei Alergush',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: const Text(
                          'andrey392live@gmail.com',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                HapticFeedback.lightImpact();
              },
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Developed by",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Andrei Alergush",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "FIESC, C4",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "2025",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }
}
