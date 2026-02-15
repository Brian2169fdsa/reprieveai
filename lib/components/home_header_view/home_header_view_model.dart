import '/components/nav_profile_button/nav_profile_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_header_view_widget.dart' show HomeHeaderViewWidget;
import 'package:flutter/material.dart';

class HomeHeaderViewModel extends FlutterFlowModel<HomeHeaderViewWidget> {
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
