import '/flutter_flow/flutter_flow_util.dart';
import 'feed_post_widget.dart' show FeedPostWidget;
import 'package:flutter/material.dart';

class FeedPostModel extends FlutterFlowModel<FeedPostWidget> {
  ///  Local state fields for this component.

  String displayName = ' ';

  int? likeCount;

  int? replyCount;

  String text = ' ';

  String? imageURL;

  DateTime? createdAt;

  List<String> youtubeVideoIds = [];
  void addToYoutubeVideoIds(String item) => youtubeVideoIds.add(item);
  void removeFromYoutubeVideoIds(String item) => youtubeVideoIds.remove(item);
  void removeAtIndexFromYoutubeVideoIds(int index) =>
      youtubeVideoIds.removeAt(index);
  void insertAtIndexInYoutubeVideoIds(int index, String item) =>
      youtubeVideoIds.insert(index, item);
  void updateYoutubeVideoIdsAtIndex(int index, Function(String) updateFn) =>
      youtubeVideoIds[index] = updateFn(youtubeVideoIds[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
