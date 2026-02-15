import '/components/goals_complete_view/goals_complete_view_widget.dart';
import '/components/home_check_in_view/home_check_in_view_widget.dart';
import '/components/home_header_view/home_header_view_widget.dart';
import '/components/home_m_o_t_d_view/home_m_o_t_d_view_widget.dart';
import '/components/home_video_row_view/home_video_row_view_widget.dart';
import '/components/home_video_tags_view/home_video_tags_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'home_view_model.dart';
export 'home_view_model.dart';

class HomeViewWidget extends StatefulWidget {
  const HomeViewWidget({super.key});

  @override
  State<HomeViewWidget> createState() => _HomeViewWidgetState();
}

class _HomeViewWidgetState extends State<HomeViewWidget> {
  late HomeViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeViewModel());

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
                model: _model.homeHeaderViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const HomeHeaderViewWidget(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 100.0,
              decoration: const BoxDecoration(),
              child: wrapWithModel(
                model: _model.homeMOTDViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const HomeMOTDViewWidget(),
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
                model: _model.goalsCompleteViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const GoalsCompleteViewWidget(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 50.0,
              decoration: const BoxDecoration(),
              child: wrapWithModel(
                model: _model.homeCheckInViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const HomeCheckInViewWidget(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 112.0,
              decoration: const BoxDecoration(),
              child: wrapWithModel(
                model: _model.homeVideoTagsViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const HomeVideoTagsViewWidget(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 112.0,
              decoration: const BoxDecoration(),
              child: wrapWithModel(
                model: _model.homeVideoRowViewModel,
                updateCallback: () => safeSetState(() {}),
                child: const HomeVideoRowViewWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
