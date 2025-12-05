import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/screens/create_account_screen.dart';
import 'package:expense_tracker/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isHiden = true;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(
        context,
      ).push(
        MaterialPageRoute(builder: (ctx) => HomeScreen()),
      );
    } catch (error) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text("Expense Tracker"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 50,
                left: 16,
                right: 16,
                bottom: 32,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 42),
                  Center(
                    child: Text(
                      "Welcome!",
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      "Log in to continue",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 56),
                  Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            label: const Text("Password"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isHiden = !_isHiden;
                                });
                              },
                              icon: Icon(
                                _isHiden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.key),
                          ),
                          obscureText: _isHiden,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 56),
                        SizedBox(
                          width: double.infinity,
                          child: FloatingActionButton(
                            elevation: 1,
                            child: const Text("Sign in"),
                            onPressed: () {
                              _submit();
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            const SizedBox(width: 2),
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        const CreateAccountScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign in",
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
