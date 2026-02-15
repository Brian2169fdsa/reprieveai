import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'community_view_model.dart';
export 'community_view_model.dart';

class CommunityViewWidget extends StatefulWidget {
  const CommunityViewWidget({super.key});

  @override
  State<CommunityViewWidget> createState() => _CommunityViewWidgetState();
}

class _CommunityViewWidgetState extends State<CommunityViewWidget>
    with TickerProviderStateMixin {
  late CommunityViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityViewModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
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
      children: [
        Align(
          alignment: const Alignment(0.0, 0),
          child: TabBar(
            labelColor: FlutterFlowTheme.of(context).primary,
            unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
            labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Readex Pro',
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                ),
            unselectedLabelStyle: const TextStyle(),
            indicatorColor: FlutterFlowTheme.of(context).primary,
            tabs: const [
              Tab(
                text: 'MEMBERS',
              ),
              Tab(
                text: 'BOARDS',
              ),
            ],
            controller: _model.tabBarController,
            onTap: (i) async {
              [() async {}, () async {}][i]();
            },
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _model.tabBarController,
            children: [
              Text(
                'Members View',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      fontSize: 32.0,
                      letterSpacing: 0.0,
                    ),
              ),
              Text(
                'Boards View',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      fontSize: 32.0,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
