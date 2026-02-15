import '/components/goals_complete_view/goals_complete_view_widget.dart';
import '/components/nav_profile_button/nav_profile_button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'home_view_test_delete02_model.dart';
export 'home_view_test_delete02_model.dart';

class HomeViewTestDelete02Widget extends StatefulWidget {
  const HomeViewTestDelete02Widget({super.key});

  @override
  State<HomeViewTestDelete02Widget> createState() =>
      _HomeViewTestDelete02WidgetState();
}

class _HomeViewTestDelete02WidgetState
    extends State<HomeViewTestDelete02Widget> {
  late HomeViewTestDelete02Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeViewTestDelete02Model());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          height: 60.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: const AlignmentDirectional(-1.0, 0.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Reprieve',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(1.0, 0.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: wrapWithModel(
                      model: _model.navProfileButtonModel,
                      updateCallback: () => safeSetState(() {}),
                      child: const NavProfileButtonWidget(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                wrapWithModel(
                  model: _model.goalsCompleteViewModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const GoalsCompleteViewWidget(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
