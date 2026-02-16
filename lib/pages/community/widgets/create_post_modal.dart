import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/pages/community/models/community_post.dart';
import '/features/goals/models/goal.dart';

class CreatePostModal extends StatefulWidget {
  final VoidCallback onPostCreated;

  const CreatePostModal({
    super.key,
    required this.onPostCreated,
  });

  @override
  State<CreatePostModal> createState() => _CreatePostModalState();
}

class _CreatePostModalState extends State<CreatePostModal> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  PostType _selectedPostType = PostType.progress;
  PostVisibility _selectedVisibility = PostVisibility.public;
  String? _linkedGoalId;
  List<Goal> _userGoals = [];
  bool _isLoading = false;
  bool _isLoadingGoals = true;

  @override
  void initState() {
    super.initState();
    _loadUserGoals();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadUserGoals() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _isLoadingGoals = false);
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('goals')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .get();

      setState(() {
        _userGoals = snapshot.docs.map((doc) => Goal.fromFirestore(doc)).toList();
        _isLoadingGoals = false;
      });
    } catch (e) {
      setState(() => _isLoadingGoals = false);
    }
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to post')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final post = CommunityPost(
        postId: '', // Will be set by Firestore
        userId: userId,
        type: _selectedPostType,
        text: _textController.text.trim(),
        linkedGoalId: _linkedGoalId,
        visibility: _selectedVisibility,
        createdAt: DateTime.now(),
        moderationStatus: 'pending',
        reactionCount: 0,
        commentCount: 0,
      );

      await FirebaseFirestore.instance
          .collection('community_posts')
          .add(post.toFirestore());

      if (mounted) {
        Navigator.pop(context);
        widget.onPostCreated();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post submitted for moderation'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating post: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Create Post',
                    style: FlutterFlowTheme.of(context).headlineSmall?.copyWith(
                          color: Colors.grey.shade900,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Post Type Selector
              Text(
                'Post Type',
                style: FlutterFlowTheme.of(context).bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<PostType>(
                value: _selectedPostType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items: PostType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(CommunityPost.postTypeDisplayName(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedPostType = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Text Input
              Text(
                'Your Post',
                style: FlutterFlowTheme.of(context).bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _textController,
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Share your thoughts...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your post';
                  }
                  if (value.trim().length > 500) {
                    return 'Post must be 500 characters or less';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Link to Goal (Optional)
              Text(
                'Link to Goal (Optional)',
                style: FlutterFlowTheme.of(context).bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
              ),
              const SizedBox(height: 8),
              _isLoadingGoals
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      value: _linkedGoalId,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      hint: const Text('Select a goal (optional)'),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('No goal linked'),
                        ),
                        ..._userGoals.map((goal) {
                          return DropdownMenuItem<String>(
                            value: goal.goalId,
                            child: Text(goal.title),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() => _linkedGoalId = value);
                      },
                    ),
              const SizedBox(height: 16),

              // Visibility Selector
              Text(
                'Visibility',
                style: FlutterFlowTheme.of(context).bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<PostVisibility>(
                value: _selectedVisibility,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items: PostVisibility.values.map((visibility) {
                  return DropdownMenuItem(
                    value: visibility,
                    child: Text(CommunityPost.visibilityDisplayName(visibility)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedVisibility = value);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Submit Post',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
