import '/components/nav_profile_button/nav_profile_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'goals_header_view_widget.dart' show GoalsHeaderViewWidget;
import 'package:flutter/material.dart';

class GoalsHeaderViewModel extends FlutterFlowModel<GoalsHeaderViewWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for NavProfileButton component.
  late NavProfileButtonModel navProfileButtonModel;

  @override
  void initState(BuildContext context) {
    navProfileButtonModel = createModel(context, () => NavProfileButtonModel());
  }

  @override
  void dispose() {
    navProfileButtonModel.dispose();
  }
}
