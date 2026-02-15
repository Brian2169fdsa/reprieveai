import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'assistant_body_view_model.dart';
export 'assistant_body_view_model.dart';

class AssistantBodyViewWidget extends StatefulWidget {
  const AssistantBodyViewWidget({super.key});

  @override
  State<AssistantBodyViewWidget> createState() =>
      _AssistantBodyViewWidgetState();
}

class _AssistantBodyViewWidgetState extends State<AssistantBodyViewWidget> {
  late AssistantBodyViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AssistantBodyViewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8.0,
            color: Color(0x0F000000),
            offset: Offset(0.0, 3.0),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.assistant_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: 48.0,
            ),
          ],
        ),
      ),
    );
  }
}
