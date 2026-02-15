import '/components/assistant_body_view/assistant_body_view_widget.dart';
import '/components/assistant_f_a_q_view/assistant_f_a_q_view_widget.dart';
import '/components/assistant_header_view/assistant_header_view_widget.dart';
import '/components/assistant_input_view/assistant_input_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'assistant_view_model.dart';
export 'assistant_view_model.dart';

class AssistantViewWidget extends StatefulWidget {
  const AssistantViewWidget({super.key});

  @override
  State<AssistantViewWidget> createState() => _AssistantViewWidgetState();
}

class _AssistantViewWidgetState extends State<AssistantViewWidget> {
  late AssistantViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AssistantViewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 51.0,
              decoration: const BoxDecoration(),
              child: wrapWithModel(
                model: _model.assistantHeaderViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const AssistantHeaderViewWidget(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 325.0,
              decoration: const BoxDecoration(),
              child: wrapWithModel(
                model: _model.assistantBodyViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const AssistantBodyViewWidget(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 125.0,
              decoration: const BoxDecoration(),
              child: wrapWithModel(
                model: _model.assistantFAQViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const AssistantFAQViewWidget(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 67.0,
              decoration: const BoxDecoration(),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 50.0,
              decoration: const BoxDecoration(),
              child: wrapWithModel(
                model: _model.assistantInputViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const AssistantInputViewWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
