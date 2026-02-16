import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/pages/community/models/community_post.dart';
import '/pages/community/widgets/post_card.dart';
import '/pages/community/models/sponsor_match.dart';

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

  // Sponsor visibility data
  String? _currentUserId;
  bool _isAdmin = false;
  Set<String> _sponsorMatchIds = {}; // IDs of users in sponsor relationships with current user

  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initializeUser() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    _currentUserId = userId;

    // Check admin status
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      _isAdmin = userDoc.data()?['isAdmin'] ?? false;
    } catch (e) {
      _isAdmin = false;
    }

    // Load sponsor matches
    await _loadSponsorMatches();

    // Load posts after user data is ready
    _loadPosts();
  }

  Future<void> _loadSponsorMatches() async {
    if (_currentUserId == null) return;

    try {
      // Get matches where user is participant
      final participantMatches = await FirebaseFirestore.instance
          .collection('sponsor_matches')
          .where('participantId', isEqualTo: _currentUserId)
          .get();

      // Get matches where user is sponsor
      final sponsorMatches = await FirebaseFirestore.instance
          .collection('sponsor_matches')
          .where('sponsorId', isEqualTo: _currentUserId)
          .get();

      final matchIds = <String>{};

      // Add all sponsor IDs (if user is participant)
      for (var doc in participantMatches.docs) {
        final match = SponsorMatch.fromFirestore(doc);
        matchIds.add(match.sponsorId);
      }

      // Add all participant IDs (if user is sponsor)
      for (var doc in sponsorMatches.docs) {
        final match = SponsorMatch.fromFirestore(doc);
        matchIds.add(match.participantId);
      }

      setState(() {
        _sponsorMatchIds = matchIds;
      });
    } catch (e) {
      // If sponsor_matches collection doesn't exist yet, continue with empty set
      _sponsorMatchIds = {};
    }
  }

  bool _canViewPost(CommunityPost post) {
    // User not logged in - only see public posts
    if (_currentUserId == null) {
      return post.visibility == PostVisibility.public;
    }

    // Post owner can always see their own posts
    if (post.userId == _currentUserId) {
      return true;
    }

    // Admin can see all posts
    if (_isAdmin) {
      return true;
    }

    // Check visibility rules
    switch (post.visibility) {
      case PostVisibility.public:
        return true;
      case PostVisibility.sponsorOnly:
        // Must be in a sponsor relationship with post owner
        return _sponsorMatchIds.contains(post.userId);
      case PostVisibility.private:
        return false; // Only owner can see (already checked above)
    }
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
        final allPosts = snapshot.docs
            .map((doc) => CommunityPost.fromFirestore(doc))
            .toList();

        // Filter posts based on visibility rules
        final visiblePosts = allPosts.where(_canViewPost).toList();

        setState(() {
          _posts = visiblePosts;
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
        final allNewPosts = snapshot.docs
            .map((doc) => CommunityPost.fromFirestore(doc))
            .toList();

        // Filter posts based on visibility rules
        final visibleNewPosts = allNewPosts.where(_canViewPost).toList();

        setState(() {
          _posts.addAll(visibleNewPosts);
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
        return FutureBuilder<Map<String, dynamic>>(
          future: _getUserData(post.userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            return PostCard(
              post: post,
              userData: snapshot.data!,
            );
          },
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

}
