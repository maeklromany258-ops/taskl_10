import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String authorId;
  final String? authorEmail;
  final String content;
  final List<String> likes;

  PostModel({
    required this.authorId,
    required this.authorEmail,
    required this.content,
    this.likes = const [],
  });

  Map<String, dynamic> toFirestore() => {
    'authorId': authorId,
    'authorEmail': authorEmail,
    'content': content,
    'likes': likes,
    'createdAt': FieldValue.serverTimestamp(),
  };
}