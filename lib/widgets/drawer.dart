import 'package:expense_tracker/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.blueGrey,
            alignment: Alignment.center,
            child: ListTile(
              title: Text(
                "Andrei Alergush",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.category),
            title: const Text("Categories"),
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.logout),
              title: const Text("Log out"),
            ),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (ctx) => const AuthSreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
