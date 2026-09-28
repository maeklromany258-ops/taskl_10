import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskl_10/screen/signup.dart';
import '../theme.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      snack(context, 'Please enter email and password');
      return;
    }
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'invalid-email' => 'The email address is not valid.',
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' =>
        'Email or password is incorrect.',
        'user-disabled' => 'This account has been disabled.',
        'too-many-requests' => 'Too many attempts. Try again later.',
        _ => e.message ?? 'Login failed.',
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const Text('🐝', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 10),
                const Text('Buzz',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: kPrimary)),
                const Text('Log in to join the conversation',
                    style: TextStyle(color: kMuted)),
                const SizedBox(height: 32),
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
                  onSubmitted: (_) => login(),
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
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: isLoading ? null : login,
                  child: isLoading
                      ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white))
                      : const Text('Login'),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SignupScreen())),
                  child: const Text("New here? Create account",
                      style: TextStyle(color: kPrimary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}