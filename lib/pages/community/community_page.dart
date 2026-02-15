import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _postController = TextEditingController();
  bool _isPosting = false;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_postController.text.trim().isEmpty) return;

    setState(() => _isPosting = true);

    try {
      final functions = FirebaseFunctions.instance;
      await functions.httpsCallable('savePost').call({
        'content': _postController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      _postController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post shared!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }

  Future<void> _likePost(String postId, bool isLiked) async {
    try {
      final functions = FirebaseFunctions.instance;
      if (isLiked) {
        await functions.httpsCallable('unlikePost').call({'postId': postId});
      } else {
        await functions.httpsCallable('likePost').call({'postId': postId});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update like')),
        );
      }
    }
  }

  Future<void> _reportPost(String postId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: const Text('Report this post as inappropriate?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Report'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final functions = FirebaseFunctions.instance;
      await functions.httpsCallable('reportPost').call({'postId': postId});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post reported')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to report post')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Create Post Section
          if (user != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _postController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isPosting ? null : _createPost,
                        icon: _isPosting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send),
                        label: Text(_isPosting ? 'Posting...' : 'Post'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Posts Feed
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('archived', isEqualTo: false)
                  .orderBy('createdAt', descending: true)
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final posts = snapshot.data?.docs ?? [];

                if (posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.forum_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No posts yet',
                          style: FlutterFlowTheme.of(context).headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to share!',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final data = post.data() as Map<String, dynamic>;
                    return _PostCard(
                      postId: post.id,
                      data: data,
                      currentUserId: user?.uid,
                      onLike: _likePost,
                      onReport: _reportPost,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final String postId;
  final Map<String, dynamic> data;
  final String? currentUserId;
  final Function(String, bool) onLike;
  final Function(String) onReport;

  const _PostCard({
    required this.postId,
    required this.data,
    required this.currentUserId,
    required this.onLike,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final content = data['content'] as String? ?? '';
    final createdAt = data['createdAt'] as Timestamp?;
    final likes = (data['likes'] as List?)?.cast<String>() ?? [];
    final isLiked = currentUserId != null && likes.contains(currentUserId);
    final userId = data['userId'] as String?;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Row
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Community Member',
                        style: FlutterFlowTheme.of(context).bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (createdAt != null)
                        Text(
                          timeago.format(createdAt.toDate()),
                          style: FlutterFlowTheme.of(context).bodySmall,
                        ),
                    ],
                  ),
                ),
                if (currentUserId != null && userId != currentUserId)
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => onReport(postId),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Content
            Text(
              content,
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
            const SizedBox(height: 12),

            // Actions Row
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed:
                      currentUserId != null ? () => onLike(postId, isLiked) : null,
                ),
                Text('${likes.length}'),
                const SizedBox(width: 16),
                const Icon(Icons.comment_outlined),
                const SizedBox(width: 4),
                const Text('0'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
