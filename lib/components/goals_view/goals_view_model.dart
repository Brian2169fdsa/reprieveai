import '/components/goals_complete_view/goals_complete_view_widget.dart';
import '/components/goals_header_view/goals_header_view_widget.dart';
import '/components/goals_m_o_t_d_view/goals_m_o_t_d_view_widget.dart';
import '/components/goals_plan_item_view/goals_plan_item_view_widget.dart';
import '/components/goals_today_view/goals_today_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'goals_view_widget.dart' show GoalsViewWidget;
import 'package:flutter/material.dart';

class GoalsViewModel extends FlutterFlowModel<GoalsViewWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for GoalsHeaderView component.
  late GoalsHeaderViewModel goalsHeaderViewModel;
  // Model for GoalsMOTDView component.
  late GoalsMOTDViewModel goalsMOTDViewModel;
  // Model for GoalsCompleteView component.
  late GoalsCompleteViewModel goalsCompleteViewModel;
  // Model for GoalsTodayView component.
  late GoalsTodayViewModel goalsTodayViewModel;
  // Model for GoalsPlanItemView component.
  late GoalsPlanItemViewModel goalsPlanItemViewModel1;
  // Model for GoalsPlanItemView component.
  late GoalsPlanItemViewModel goalsPlanItemViewModel2;
  // Model for GoalsPlanItemView component.
  late GoalsPlanItemViewModel goalsPlanItemViewModel3;

  @override
  void initState(BuildContext context) {
    goalsHeaderViewModel = createModel(context, () => GoalsHeaderViewModel());
    goalsMOTDViewModel = createModel(context, () => GoalsMOTDViewModel());
    goalsCompleteViewModel =
        createModel(context, () => GoalsCompleteViewModel());
    goalsTodayViewModel = createModel(context, () => GoalsTodayViewModel());
    goalsPlanItemViewModel1 =
        createModel(context, () => GoalsPlanItemViewModel());
    goalsPlanItemViewModel2 =
        createModel(context, () => GoalsPlanItemViewModel());
    goalsPlanItemViewModel3 =
        createModel(context, () => GoalsPlanItemViewModel());
  }

  @override
  void dispose() {
    goalsHeaderViewModel.dispose();
    goalsMOTDViewModel.dispose();
    goalsCompleteViewModel.dispose();
    goalsTodayViewModel.dispose();
    goalsPlanItemViewModel1.dispose();
    goalsPlanItemViewModel2.dispose();
    goalsPlanItemViewModel3.dispose();
  }
}
