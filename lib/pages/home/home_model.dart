import '/components/assistant_view/assistant_view_widget.dart';
import '/components/home_view/home_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for HomeView component.
  late HomeViewModel homeViewModel;
  // Model for AssistantView component.
  late AssistantViewModel assistantViewModel;

  @override
  void initState(BuildContext context) {
    homeViewModel = createModel(context, () => HomeViewModel());
    assistantViewModel = createModel(context, () => AssistantViewModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    homeViewModel.dispose();
    assistantViewModel.dispose();
  }
}
