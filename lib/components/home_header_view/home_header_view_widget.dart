import '/components/nav_profile_button/nav_profile_button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'home_header_view_model.dart';
export 'home_header_view_model.dart';

class HomeHeaderViewWidget extends StatefulWidget {
  const HomeHeaderViewWidget({super.key});

  @override
  State<HomeHeaderViewWidget> createState() => _HomeHeaderViewWidgetState();
}

class _HomeHeaderViewWidgetState extends State<HomeHeaderViewWidget> {
  late HomeHeaderViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeHeaderViewModel());

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
            'Reprieve',
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
