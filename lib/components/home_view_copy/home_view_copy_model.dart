import '/components/goals_complete_view/goals_complete_view_widget.dart';
import '/components/home_check_in_view/home_check_in_view_widget.dart';
import '/components/home_header_view/home_header_view_widget.dart';
import '/components/home_m_o_t_d_view/home_m_o_t_d_view_widget.dart';
import '/components/home_video_row_view/home_video_row_view_widget.dart';
import '/components/home_video_tags_view/home_video_tags_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_view_copy_widget.dart' show HomeViewCopyWidget;
import 'package:flutter/material.dart';

class HomeViewCopyModel extends FlutterFlowModel<HomeViewCopyWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for HomeHeaderView component.
  late HomeHeaderViewModel homeHeaderViewModel;
  // Model for HomeMOTDView component.
  late HomeMOTDViewModel homeMOTDViewModel;
  // Model for GoalsCompleteView component.
  late GoalsCompleteViewModel goalsCompleteViewModel;
  // Model for HomeCheckInView component.
  late HomeCheckInViewModel homeCheckInViewModel;
  // Model for HomeVideoTagsView component.
  late HomeVideoTagsViewModel homeVideoTagsViewModel;
  // Model for HomeVideoRowView component.
  late HomeVideoRowViewModel homeVideoRowViewModel;

  @override
  void initState(BuildContext context) {
    homeHeaderViewModel = createModel(context, () => HomeHeaderViewModel());
    homeMOTDViewModel = createModel(context, () => HomeMOTDViewModel());
    goalsCompleteViewModel =
        createModel(context, () => GoalsCompleteViewModel());
    homeCheckInViewModel = createModel(context, () => HomeCheckInViewModel());
    homeVideoTagsViewModel =
        createModel(context, () => HomeVideoTagsViewModel());
    homeVideoRowViewModel = createModel(context, () => HomeVideoRowViewModel());
  }

  @override
  void dispose() {
    homeHeaderViewModel.dispose();
    homeMOTDViewModel.dispose();
    goalsCompleteViewModel.dispose();
    homeCheckInViewModel.dispose();
    homeVideoTagsViewModel.dispose();
    homeVideoRowViewModel.dispose();
  }
}
