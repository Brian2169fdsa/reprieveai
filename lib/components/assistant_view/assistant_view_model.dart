import '/components/assistant_body_view/assistant_body_view_widget.dart';
import '/components/assistant_f_a_q_view/assistant_f_a_q_view_widget.dart';
import '/components/assistant_header_view/assistant_header_view_widget.dart';
import '/components/assistant_input_view/assistant_input_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'assistant_view_widget.dart' show AssistantViewWidget;
import 'package:flutter/material.dart';

class AssistantViewModel extends FlutterFlowModel<AssistantViewWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for AssistantHeaderView component.
  late AssistantHeaderViewModel assistantHeaderViewModel;
  // Model for AssistantBodyView component.
  late AssistantBodyViewModel assistantBodyViewModel;
  // Model for AssistantFAQView component.
  late AssistantFAQViewModel assistantFAQViewModel;
  // Model for AssistantInputView component.
  late AssistantInputViewModel assistantInputViewModel;

  @override
  void initState(BuildContext context) {
    assistantHeaderViewModel =
        createModel(context, () => AssistantHeaderViewModel());
    assistantBodyViewModel =
        createModel(context, () => AssistantBodyViewModel());
    assistantFAQViewModel = createModel(context, () => AssistantFAQViewModel());
    assistantInputViewModel =
        createModel(context, () => AssistantInputViewModel());
  }

  @override
  void dispose() {
    assistantHeaderViewModel.dispose();
    assistantBodyViewModel.dispose();
    assistantFAQViewModel.dispose();
    assistantInputViewModel.dispose();
  }
}
