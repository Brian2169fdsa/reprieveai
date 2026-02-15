import '/flutter_flow/flutter_flow_util.dart';
import 'community_view_widget.dart' show CommunityViewWidget;
import 'package:flutter/material.dart';

class CommunityViewModel extends FlutterFlowModel<CommunityViewWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
