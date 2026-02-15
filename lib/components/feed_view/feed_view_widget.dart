import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/feed_post/feed_post_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'feed_view_model.dart';
export 'feed_view_model.dart';

class FeedViewWidget extends StatefulWidget {
  const FeedViewWidget({super.key});

  @override
  State<FeedViewWidget> createState() => _FeedViewWidgetState();
}

class _FeedViewWidgetState extends State<FeedViewWidget> {
  late FeedViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FeedViewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<DocumentSnapshot<Object?>?, PostsRecord>(
      pagingController: _model.setListViewController(
        PostsRecord.collection
            .where(
              'archived',
              isEqualTo: false,
            )
            .where(
              'dev',
              isEqualTo: false,
            )
            .where(
              'source',
              isEqualTo: PostSources.feed.name,
            )
            .where(
              'isReply',
              isEqualTo: false,
            )
            .orderBy('createdAt', descending: true),
      ),
      padding: EdgeInsets.zero,
      reverse: false,
      scrollDirection: Axis.vertical,
      builderDelegate: PagedChildBuilderDelegate<PostsRecord>(
        // Customize what your widget looks like when it's loading the first page.
        firstPageProgressIndicatorBuilder: (_) => Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),
        // Customize what your widget looks like when it's loading another page.
        newPageProgressIndicatorBuilder: (_) => Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),

        itemBuilder: (context, _, listViewIndex) {
          final listViewPostsRecord =
              _model.listViewPagingController!.itemList![listViewIndex];
          return FeedPostWidget(
            key: Key(
                'Key9ic_${listViewIndex}_of_${_model.listViewPagingController!.itemList!.length}'),
            displayName: listViewPostsRecord.authorDisplayName,
            text: listViewPostsRecord.text,
            likeCount: valueOrDefault<int>(
              listViewPostsRecord.likedBy.length,
              0,
            ),
            replyCount: valueOrDefault<int>(
              listViewPostsRecord.replies.length,
              0,
            ),
            imageURL: listViewPostsRecord.authorProfilePicURL,
            createdAt: listViewPostsRecord.createdAt ?? DateTime.now(),
          );
        },
      ),
    );
  }
}
