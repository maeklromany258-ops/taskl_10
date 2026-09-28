import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screen/post_screen.dart';
import '../theme.dart';


class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  CollectionReference get posts =>
      FirebaseFirestore.instance.collection('posts');

  Future<void> toggleLike(String id, String uid, List likes) {
    return posts.doc(id).update({
      'likes': likes.contains(uid)
          ? FieldValue.arrayRemove([uid])
          : FieldValue.arrayUnion([uid]),
    });
  }

  void confirm(BuildContext context, String title, String body,
      Future<void> Function() onYes) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: kMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await onYes();
            },
            child: const Text('Yes', style: TextStyle(color: kPrimary)),
          ),
        ],
      ),
    );
  }

  void openPost(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (_) => const PostScreen()));

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buzz 🐝'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => confirm(context, 'Logout',
                'Do you want to logout?', () => FirebaseAuth.instance.signOut()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openPost(context),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.edit_rounded),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: posts.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: kPrimary));
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('pp', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 12),
                  const Text('Nothing here yet',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(180, 48)),
                    onPressed: () => openPost(context),
                    child: const Text('Write first post'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data() as Map<String, dynamic>;
              final id = docs[i].id;
              final likes = List.from(d['likes'] ?? []);
              final email = (d['authorEmail'] ?? 'Anonymous') as String;
              final liked = likes.contains(uid);
              final mine = d['authorId'] == uid;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 12,
                        offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFFE3DB),
                          child: Text(
                            email.isNotEmpty ? email[0].toUpperCase() : '?',
                            style: const TextStyle(
                                color: kPrimary, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, color: kText)),
                        ),
                        if (mine)
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: kMuted),
                            onPressed: () => confirm(
                                context,
                                'Delete post?',
                                'This cannot be undone.',
                                    () => posts.doc(id).delete()),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(d['content'] ?? '',
                        style: const TextStyle(
                            fontSize: 15, height: 1.5, color: kText)),
                    const SizedBox(height: 10),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => toggleLike(id, uid, likes),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              liked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: liked ? kPrimary : kMuted,
                            ),
                            const SizedBox(width: 6),
                            Text('${likes.length}',
                                style: const TextStyle(color: kMuted)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}