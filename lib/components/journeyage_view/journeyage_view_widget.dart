import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'journeyage_view_model.dart';
export 'journeyage_view_model.dart';

class JourneyageViewWidget extends StatefulWidget {
  const JourneyageViewWidget({super.key});

  @override
  State<JourneyageViewWidget> createState() => _JourneyageViewWidgetState();
}

class _JourneyageViewWidgetState extends State<JourneyageViewWidget> {
  late JourneyageViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => JourneyageViewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterFlowWebView(
      content: functions.getURL(_model.lastVisitedURL, currentJwtToken),
      bypass: false,
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: MediaQuery.sizeOf(context).height * 1.0,
      verticalScroll: false,
      horizontalScroll: false,
    );
  }
}
