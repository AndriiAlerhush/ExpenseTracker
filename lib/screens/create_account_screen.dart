import 'package:expense_tracker/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  // final _confirmPasswordController = TextEditingController();
  bool _isHidenPass = true;
  bool _isHidenConfPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        toolbarHeight: 50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 60,
                left: 16,
                right: 16,
                bottom: 32,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Create Account",
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      "Complete to start",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 56),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            label: const Text("Username"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _usernameController.text = "";
                              },
                              icon: const Icon(Icons.highlight_off_rounded),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            label: const Text("Email"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _emailController.text = "";
                              },
                              icon: const Icon(Icons.highlight_off_rounded),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          decoration: InputDecoration(
                            label: const Text("Password"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isHidenPass = !_isHidenPass;
                                });
                              },
                              icon: Icon(
                                _isHidenPass
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.key),
                          ),
                          obscureText: _isHidenPass,
                          autocorrect: false,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          decoration: InputDecoration(
                            label: const Text("Confirm Password"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isHidenConfPass = !_isHidenConfPass;
                                });
                              },
                              icon: Icon(
                                _isHidenConfPass
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.key),
                          ),
                          obscureText: _isHidenConfPass,
                          autocorrect: false,
                        ),
                        const SizedBox(height: 56),
                        SizedBox(
                          width: double.infinity,
                          child: FloatingActionButton(
                            elevation: 1,
                            child: const Text("Sign up"),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            const SizedBox(width: 2),
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (ctx) => const AuthScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Log in",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
