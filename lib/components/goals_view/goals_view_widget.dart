import '/components/goals_complete_view/goals_complete_view_widget.dart';
import '/components/goals_header_view/goals_header_view_widget.dart';
import '/components/goals_m_o_t_d_view/goals_m_o_t_d_view_widget.dart';
import '/components/goals_plan_item_view/goals_plan_item_view_widget.dart';
import '/components/goals_today_view/goals_today_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'goals_view_model.dart';
export 'goals_view_model.dart';

class GoalsViewWidget extends StatefulWidget {
  const GoalsViewWidget({super.key});

  @override
  State<GoalsViewWidget> createState() => _GoalsViewWidgetState();
}

class _GoalsViewWidgetState extends State<GoalsViewWidget> {
  late GoalsViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GoalsViewModel());

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
                model: _model.goalsHeaderViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const GoalsHeaderViewWidget(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 6.0),
            child: Container(
              width: double.infinity,
              height: 86.0,
              decoration: const BoxDecoration(),
              child: wrapWithModel(
                model: _model.goalsMOTDViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const GoalsMOTDViewWidget(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 6.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 325.0,
              decoration: const BoxDecoration(),
              child: wrapWithModel(
                model: _model.goalsCompleteViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const GoalsCompleteViewWidget(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 6.0, 20.0, 6.0),
            child: Container(
              width: double.infinity,
              height: 80.0,
              decoration: const BoxDecoration(),
              child: wrapWithModel(
                model: _model.goalsTodayViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const GoalsTodayViewWidget(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 6.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 198.0,
              decoration: const BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: wrapWithModel(
                      model: _model.goalsPlanItemViewModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: const GoalsPlanItemViewWidget(),
                    ),
                  ),
                  Expanded(
                    child: wrapWithModel(
                      model: _model.goalsPlanItemViewModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: const GoalsPlanItemViewWidget(),
                    ),
                  ),
                  Expanded(
                    child: wrapWithModel(
                      model: _model.goalsPlanItemViewModel3,
                      updateCallback: () => safeSetState(() {}),
                      child: const GoalsPlanItemViewWidget(),
                    ),
                  ),
                ].divide(const SizedBox(height: 5.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
