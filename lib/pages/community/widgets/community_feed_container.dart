import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/pages/community/models/community_post.dart';

class CommunityFeedContainer extends StatefulWidget {
  const CommunityFeedContainer({super.key});

  @override
  State<CommunityFeedContainer> createState() => CommunityFeedContainerState();
}

class CommunityFeedContainerState extends State<CommunityFeedContainer> {
  List<CommunityPost> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('community_posts')
          .where('moderationStatus', isEqualTo: 'approved')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      setState(() {
        _posts = snapshot.docs
            .map((doc) => CommunityPost.fromFirestore(doc))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void refreshFeed() {
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_posts.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final post = _posts[index];
        return _buildPostCard(
          context,
          post: post,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
            'No community posts yet.',
            style: FlutterFlowTheme.of(context).headlineSmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share!',
            style: FlutterFlowTheme.of(context).bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context, {
    required CommunityPost post,
  }) {
    // Format timestamp
    final now = DateTime.now();
    final difference = now.difference(post.createdAt);
    String timestamp;
    if (difference.inMinutes < 60) {
      timestamp = '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      timestamp = '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      timestamp = '${difference.inDays}d ago';
    } else {
      timestamp = '${post.createdAt.month}/${post.createdAt.day}/${post.createdAt.year}';
    }

    return Card(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Type Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                CommunityPost.postTypeDisplayName(post.type),
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Header: Avatar + Name + Timestamp
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
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
                              color: Colors.grey.shade900,
                            ),
                      ),
                      Text(
                        timestamp,
                        style: FlutterFlowTheme.of(context).bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Content
            Text(
              post.text,
              style: FlutterFlowTheme.of(context).bodyMedium?.copyWith(
                    color: Colors.grey.shade800,
                  ),
            ),
            const SizedBox(height: 12),

            // Reaction bar
            Row(
              children: [
                _buildReactionButton(
                  context,
                  icon: Icons.favorite_border,
                  label: '${post.reactionCount}',
                ),
                const SizedBox(width: 16),
                _buildReactionButton(
                  context,
                  icon: Icons.comment_outlined,
                  label: '${post.commentCount}',
                ),
                const SizedBox(width: 16),
                _buildReactionButton(
                  context,
                  icon: Icons.share_outlined,
                  label: 'Share',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return InkWell(
      onTap: () {
        // Placeholder - reactions coming soon
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
