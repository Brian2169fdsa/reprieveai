import '/components/home_m_o_t_d_view/home_m_o_t_d_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_view_test_d_e_l_e_t_e_widget.dart' show HomeViewTestDELETEWidget;
import 'package:flutter/material.dart';

class HomeViewTestDELETEModel
    extends FlutterFlowModel<HomeViewTestDELETEWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for HomeMOTDView component.
  late HomeMOTDViewModel homeMOTDViewModel;

  @override
  void initState(BuildContext context) {
    homeMOTDViewModel = createModel(context, () => HomeMOTDViewModel());
  }

  @override
  void dispose() {
    homeMOTDViewModel.dispose();
  }
}
