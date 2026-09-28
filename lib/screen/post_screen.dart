import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/post.dart';

import '../theme.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final controller = TextEditingController();
  static const maxLength = 300;
  bool isLoading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> publish() async {
    final text = controller.text.trim();
    final user = FirebaseAuth.instance.currentUser;
    if (text.isEmpty) {
      snack(context, 'Please write something first.');
      return;
    }
    if (user == null) return;

    setState(() => isLoading = true);
    try {
      final post = PostModel(
          authorId: user.uid, authorEmail: user.email, content: text);
      await FirebaseFirestore.instance
          .collection('posts')
          .add(post.toFirestore());
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
      snack(context, 'Failed to publish post.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Post')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: controller,
                maxLines: 8,
                maxLength: maxLength,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "What's buzzing?",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: kPrimary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: isLoading ? null : publish,
                child: isLoading
                    ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white))
                    : const Text('Publish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}