import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool isLoading = false;
  bool obscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      snack(context, 'Please fill in all fields.');
      return;
    }
    if (pass != confirm) {
      snack(context, 'Passwords do not match.');
      return;
    }
    if (pass.length < 6) {
      snack(context, 'Password must be at least 6 characters.');
      return;
    }

    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'email-already-in-use' => 'This email is already registered.',
        'invalid-email' => 'Please enter a valid email address.',
        'weak-password' => 'The password is too weak.',
        'operation-not-allowed' => 'Email/Password sign-in is not enabled.',
        _ => e.message ?? 'Sign up failed.',
      };
      if (mounted) snack(context, msg);
    } catch (_) {
      if (mounted) snack(context, 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Text('Create account',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: kPrimary)),
              const SizedBox(height: 28),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: inputDeco('Email', Icons.email_outlined),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: passwordController,
                obscureText: obscure,
                textInputAction: TextInputAction.next,
                decoration: inputDeco(
                  'Password',
                  Icons.lock_outline_rounded,
                  suffix: IconButton(
                    onPressed: () => setState(() => obscure = !obscure),
                    icon: Icon(obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: confirmController,
                obscureText: obscure,
                onSubmitted: (_) => signup(),
                decoration:
                inputDeco('Confirm password', Icons.verified_user_outlined),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: isLoading ? null : signup,
                child: isLoading
                    ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white))
                    : const Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}