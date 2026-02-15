import '/components/goals_complete_view/goals_complete_view_widget.dart';
import '/components/nav_profile_button/nav_profile_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_view_test_delete02_widget.dart' show HomeViewTestDelete02Widget;
import 'package:flutter/material.dart';

class HomeViewTestDelete02Model
    extends FlutterFlowModel<HomeViewTestDelete02Widget> {
  ///  State fields for stateful widgets in this component.

  // Model for NavProfileButton component.
  late NavProfileButtonModel navProfileButtonModel;
  // Model for GoalsCompleteView component.
  late GoalsCompleteViewModel goalsCompleteViewModel;

  @override
  void initState(BuildContext context) {
    navProfileButtonModel = createModel(context, () => NavProfileButtonModel());
    goalsCompleteViewModel =
        createModel(context, () => GoalsCompleteViewModel());
  }

  @override
  void dispose() {
    navProfileButtonModel.dispose();
    goalsCompleteViewModel.dispose();
  }
}
