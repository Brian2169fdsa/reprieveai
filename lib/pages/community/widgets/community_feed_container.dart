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
  final ScrollController _scrollController = ScrollController();
  final Map<String, Map<String, dynamic>> _userCache = {};

  List<CommunityPost> _posts = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _posts.clear();
      _lastDocument = null;
      _hasMore = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('community_posts')
          .where('moderationStatus', isEqualTo: 'approved')
          .orderBy('createdAt', descending: true)
          .limit(_pageSize)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        final posts = snapshot.docs
            .map((doc) => CommunityPost.fromFirestore(doc))
            .toList();

        setState(() {
          _posts = posts;
          _hasMore = snapshot.docs.length == _pageSize;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || !_hasMore || _lastDocument == null) return;

    setState(() => _isLoadingMore = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('community_posts')
          .where('moderationStatus', isEqualTo: 'approved')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(_pageSize)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        final newPosts = snapshot.docs
            .map((doc) => CommunityPost.fromFirestore(doc))
            .toList();

        setState(() {
          _posts.addAll(newPosts);
          _hasMore = snapshot.docs.length == _pageSize;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _hasMore = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() => _isLoadingMore = false);
    }
  }

  Future<Map<String, dynamic>> _getUserData(String userId) async {
    // Check cache first
    if (_userCache.containsKey(userId)) {
      return _userCache[userId]!;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() ?? {};
        final userData = {
          'displayName': data['displayName'] ?? 'Community Member',
          'photoUrl': data['photoUrl'],
        };
        _userCache[userId] = userData;
        return userData;
      }
    } catch (e) {
      // Return default if error
    }

    final defaultData = {
      'displayName': 'Community Member',
      'photoUrl': null,
    };
    _userCache[userId] = defaultData;
    return defaultData;
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
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length + (_isLoadingMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == _posts.length) {
          // Loading indicator at bottom
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final post = _posts[index];
        return _buildPostCard(context, post: post);
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
    if (difference.inMinutes < 1) {
      timestamp = 'Just now';
    } else if (difference.inMinutes < 60) {
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

            // Header: Avatar + Name + Timestamp (with lazy-loaded user data)
            FutureBuilder<Map<String, dynamic>>(
              future: _getUserData(post.userId),
              builder: (context, snapshot) {
                final displayName = snapshot.data?['displayName'] ?? 'Community Member';
                final photoUrl = snapshot.data?['photoUrl'];

                return Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                      child: photoUrl == null
                          ? Text(
                              displayName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
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
                );
              },
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

            // Reaction bar (placeholder)
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
