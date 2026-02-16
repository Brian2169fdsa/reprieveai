import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/pages/community/models/community_post.dart';
import '/pages/community/models/community_comment.dart';
import '/pages/community/models/community_reaction.dart';

class PostCard extends StatefulWidget {
  final CommunityPost post;
  final Map<String, dynamic> userData;

  const PostCard({
    super.key,
    required this.post,
    required this.userData,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showComments = false;
  bool _showAllComments = false;
  final TextEditingController _commentController = TextEditingController();

  List<CommunityComment> _comments = [];
  ReactionType? _userReaction;
  int _localReactionCount = 0;
  int _localCommentCount = 0;
  bool _isLoadingComments = false;
  bool _isSubmittingComment = false;

  @override
  void initState() {
    super.initState();
    _localReactionCount = widget.post.reactionCount;
    _localCommentCount = widget.post.commentCount;
    _loadUserReaction();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadUserReaction() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('community_reactions')
          .where('postId', isEqualTo: widget.post.postId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _userReaction = CommunityReaction.fromFirestore(snapshot.docs.first).reactionType;
        });
      }
    } catch (e) {
      // Error loading reaction
    }
  }

  Future<void> _loadComments() async {
    if (_isLoadingComments) return;

    setState(() => _isLoadingComments = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('community_comments')
          .where('postId', isEqualTo: widget.post.postId)
          .where('moderationStatus', isEqualTo: 'approved')
          .orderBy('createdAt', descending: false)
          .limit(_showAllComments ? 100 : 3)
          .get();

      setState(() {
        _comments = snapshot.docs
            .map((doc) => CommunityComment.fromFirestore(doc))
            .toList();
        _isLoadingComments = false;
      });
    } catch (e) {
      setState(() => _isLoadingComments = false);
    }
  }

  Future<void> _toggleReaction(ReactionType type) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final reactionRef = FirebaseFirestore.instance
          .collection('community_reactions')
          .doc('${widget.post.postId}_$userId');

      if (_userReaction == type) {
        // Remove reaction
        await reactionRef.delete();
        await FirebaseFirestore.instance
            .collection('community_posts')
            .doc(widget.post.postId)
            .update({'reactionCount': FieldValue.increment(-1)});

        setState(() {
          _userReaction = null;
          _localReactionCount = (_localReactionCount - 1).clamp(0, 999999);
        });
      } else {
        // Add or change reaction
        final reaction = CommunityReaction(
          postId: widget.post.postId,
          userId: userId,
          reactionType: type,
        );

        await reactionRef.set(reaction.toFirestore());

        // Only increment if it's a new reaction (not changing existing)
        if (_userReaction == null) {
          await FirebaseFirestore.instance
              .collection('community_posts')
              .doc(widget.post.postId)
              .update({'reactionCount': FieldValue.increment(1)});

          setState(() {
            _userReaction = type;
            _localReactionCount++;
          });
        } else {
          setState(() {
            _userReaction = type;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating reaction: $e')),
      );
    }
  }

  Future<void> _submitComment() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || _commentController.text.trim().isEmpty) return;

    setState(() => _isSubmittingComment = true);

    try {
      final comment = CommunityComment(
        commentId: '',
        postId: widget.post.postId,
        userId: userId,
        text: _commentController.text.trim(),
        createdAt: DateTime.now(),
        moderationStatus: 'pending',
      );

      await FirebaseFirestore.instance
          .collection('community_comments')
          .add(comment.toFirestore());

      await FirebaseFirestore.instance
          .collection('community_posts')
          .doc(widget.post.postId)
          .update({'commentCount': FieldValue.increment(1)});

      setState(() {
        _localCommentCount++;
        _commentController.clear();
        _isSubmittingComment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment submitted for moderation'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isSubmittingComment = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting comment: $e')),
      );
    }
  }

  String _formatTimestamp(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.month}/${createdAt.day}/${createdAt.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = _formatTimestamp(widget.post.createdAt);

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
                CommunityPost.postTypeDisplayName(widget.post.type),
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
                  backgroundImage: widget.userData['photoUrl'] != null
                      ? NetworkImage(widget.userData['photoUrl'])
                      : null,
                  child: widget.userData['photoUrl'] == null
                      ? Text(
                          widget.userData['displayName'][0].toUpperCase(),
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
                        widget.userData['displayName'],
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
              widget.post.text,
              style: FlutterFlowTheme.of(context).bodyMedium?.copyWith(
                    color: Colors.grey.shade800,
                  ),
            ),
            const SizedBox(height: 16),

            // Reaction Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReactionType.values.map((type) {
                final isSelected = _userReaction == type;
                return InkWell(
                  onTap: () => _toggleReaction(type),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? FlutterFlowTheme.of(context).primary
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      CommunityReaction.reactionTypeEmoji(type),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Stats and Actions Bar
            Row(
              children: [
                Text(
                  '$_localReactionCount ${_localReactionCount == 1 ? 'reaction' : 'reactions'}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showComments = !_showComments;
                      if (_showComments && _comments.isEmpty) {
                        _loadComments();
                      }
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.comment_outlined, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '$_localCommentCount ${_localCommentCount == 1 ? 'comment' : 'comments'}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Comments Section
            if (_showComments) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Comments List
              if (_isLoadingComments)
                const Center(child: CircularProgressIndicator())
              else if (_comments.isEmpty)
                Center(
                  child: Text(
                    'No comments yet',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                )
              else
                ..._comments.map((comment) => _buildCommentItem(comment)),

              // View More Button
              if (_comments.length >= 3 && !_showAllComments)
                TextButton(
                  onPressed: () {
                    setState(() => _showAllComments = true);
                    _loadComments();
                  },
                  child: const Text('View more comments'),
                ),

              const SizedBox(height: 12),

              // Add Comment Input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      maxLength: 300,
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isSubmittingComment ? null : _submitComment,
                    icon: _isSubmittingComment
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            Icons.send,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(CommunityComment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(comment.userId)
            .get(),
        builder: (context, snapshot) {
          final displayName = snapshot.data?.data() != null
              ? (snapshot.data!.data() as Map<String, dynamic>)['displayName'] ?? 'User'
              : 'User';

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: FlutterFlowTheme.of(context).primary,
                child: Text(
                  displayName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTimestamp(comment.createdAt),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.text,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
