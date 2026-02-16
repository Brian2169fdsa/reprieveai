import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/pages/community/widgets/community_feed_container.dart';
import '/pages/community/widgets/create_post_modal.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final GlobalKey<CommunityFeedContainerState> _feedKey = GlobalKey();

  void _showCreatePostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreatePostModal(
        onPostCreated: () {
          // Refresh the feed
          _feedKey.currentState?.refreshFeed();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Placeholder - notifications coming soon
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Placeholder - filter coming soon
            },
            tooltip: 'Filter',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Feed (70%)
                Expanded(
                  flex: 7,
                  child: CommunityFeedContainer(key: _feedKey),
                ),
                // Sidebar (30%)
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community Info',
                          style: FlutterFlowTheme.of(context).titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Sidebar content coming soon...',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : CommunityFeedContainer(key: _feedKey),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostModal,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
