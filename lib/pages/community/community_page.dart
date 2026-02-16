import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/pages/community/widgets/community_feed_container.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  void _showCreatePostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Post',
                style: FlutterFlowTheme.of(context).headlineSmall,
              ),
              const SizedBox(height: 16),
              const Text('Post creation coming soon...'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
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
                  child: const CommunityFeedContainer(),
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
          : const CommunityFeedContainer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostModal,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
