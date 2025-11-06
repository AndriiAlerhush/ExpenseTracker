import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.blue,
              alignment: Alignment.center,
              child: ListTile(
                leading: Icon(Icons.attach_money),
                title: Text(
                  "Expense Tracker",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.category),
              title: const Text("Categories"),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 3,
            clipBehavior: Clip.hardEdge,
            child: Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey,
              alignment: AlignmentGeometry.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text("Day"),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Week"),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Month"),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Year"),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Period"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text("Today"),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 86,
                          backgroundColor: Colors.blue,
                        ),
                        const SizedBox(width: 32),
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.add),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
