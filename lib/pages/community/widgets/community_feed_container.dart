import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class CommunityFeedContainer extends StatelessWidget {
  const CommunityFeedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - 5 placeholder posts
    final mockPosts = [
      {
        'name': 'Alex Johnson',
        'timestamp': '2 hours ago',
        'content': 'Just completed my first week in the program. Feeling hopeful and supported by this amazing community!',
      },
      {
        'name': 'Sam Martinez',
        'timestamp': '5 hours ago',
        'content': 'The mindfulness exercises from today\'s session really helped me stay grounded. Thank you all for being here.',
      },
      {
        'name': 'Jordan Lee',
        'timestamp': '1 day ago',
        'content': 'Does anyone have tips for managing stress during the job search process? Would love to hear what worked for you.',
      },
      {
        'name': 'Taylor Brown',
        'timestamp': '2 days ago',
        'content': 'Celebrating 30 days of progress today! One day at a time. This community keeps me motivated.',
      },
      {
        'name': 'Casey Davis',
        'timestamp': '3 days ago',
        'content': 'The peer support group meeting yesterday was exactly what I needed. Grateful for everyone who shared their stories.',
      },
    ];

    // Check if we have posts (in this case we always do for mock)
    if (mockPosts.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: mockPosts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final post = mockPosts[index];
        return _buildPostCard(
          context,
          name: post['name']!,
          timestamp: post['timestamp']!,
          content: post['content']!,
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
    required String name,
    required String timestamp,
    required String content,
  }) {
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
            // Header: Avatar + Name + Timestamp
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  child: Text(
                    name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
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
              content,
              style: FlutterFlowTheme.of(context).bodyMedium?.copyWith(
                    color: Colors.grey.shade800,
                  ),
            ),
            const SizedBox(height: 12),

            // Reaction bar placeholder
            Row(
              children: [
                _buildReactionButton(
                  context,
                  icon: Icons.favorite_border,
                  label: '0',
                ),
                const SizedBox(width: 16),
                _buildReactionButton(
                  context,
                  icon: Icons.comment_outlined,
                  label: '0',
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
