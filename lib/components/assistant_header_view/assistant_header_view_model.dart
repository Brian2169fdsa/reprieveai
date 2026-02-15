import '/components/nav_profile_button/nav_profile_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'assistant_header_view_widget.dart' show AssistantHeaderViewWidget;
import 'package:flutter/material.dart';

class AssistantHeaderViewModel
    extends FlutterFlowModel<AssistantHeaderViewWidget> {
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
