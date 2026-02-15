import '/components/nav_profile_button/nav_profile_button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'goals_header_view_model.dart';
export 'goals_header_view_model.dart';

class GoalsHeaderViewWidget extends StatefulWidget {
  const GoalsHeaderViewWidget({super.key});

  @override
  State<GoalsHeaderViewWidget> createState() => _GoalsHeaderViewWidgetState();
}

class _GoalsHeaderViewWidgetState extends State<GoalsHeaderViewWidget> {
  late GoalsHeaderViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GoalsHeaderViewModel());

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
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Goals',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primary,
                  letterSpacing: 0.0,
                ),
          ),
          const Spacer(),
          wrapWithModel(
            model: _model.navProfileButtonModel,
            updateCallback: () => safeSetState(() {}),
            child: const NavProfileButtonWidget(),
          ),
        ],
      ),
    );
  }
}
