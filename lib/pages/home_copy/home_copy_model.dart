import '/components/chat_view/chat_view_widget.dart';
import '/components/community_view/community_view_widget.dart';
import '/components/feed_view/feed_view_widget.dart';
import '/components/journeyage_view/journeyage_view_widget.dart';
import '/components/nav_plus_button/nav_plus_button_widget.dart';
import '/components/nav_profile_button/nav_profile_button_widget.dart';
import '/components/resources_view/resources_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_copy_widget.dart' show HomeCopyWidget;
import 'package:flutter/material.dart';

class HomeCopyModel extends FlutterFlowModel<HomeCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for JourneyageView component.
  late JourneyageViewModel journeyageViewModel;
  // Model for CommunityView component.
  late CommunityViewModel communityViewModel;
  // Model for FeedView component.
  late FeedViewModel feedViewModel;
  // Model for ResourcesView component.
  late ResourcesViewModel resourcesViewModel;
  // Model for ChatView component.
  late ChatViewModel chatViewModel;
  // Model for NavProfileButton component.
  late NavProfileButtonModel navProfileButtonModel;
  // Model for NavPlusButton component.
  late NavPlusButtonModel navPlusButtonModel;

  @override
  void initState(BuildContext context) {
    journeyageViewModel = createModel(context, () => JourneyageViewModel());
    communityViewModel = createModel(context, () => CommunityViewModel());
    feedViewModel = createModel(context, () => FeedViewModel());
    resourcesViewModel = createModel(context, () => ResourcesViewModel());
    chatViewModel = createModel(context, () => ChatViewModel());
    navProfileButtonModel = createModel(context, () => NavProfileButtonModel());
    navPlusButtonModel = createModel(context, () => NavPlusButtonModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    journeyageViewModel.dispose();
    communityViewModel.dispose();
    feedViewModel.dispose();
    resourcesViewModel.dispose();
    chatViewModel.dispose();
    navProfileButtonModel.dispose();
    navPlusButtonModel.dispose();
  }
}
