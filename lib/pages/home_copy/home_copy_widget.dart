import '/components/chat_view/chat_view_widget.dart';
import '/components/community_view/community_view_widget.dart';
import '/components/feed_view/feed_view_widget.dart';
import '/components/journeyage_view/journeyage_view_widget.dart';
import '/components/nav_plus_button/nav_plus_button_widget.dart';
import '/components/nav_profile_button/nav_profile_button_widget.dart';
import '/components/resources_view/resources_view_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'home_copy_model.dart';
export 'home_copy_model.dart';

class HomeCopyWidget extends StatefulWidget {
  const HomeCopyWidget({super.key});

  @override
  State<HomeCopyWidget> createState() => _HomeCopyWidgetState();
}

class _HomeCopyWidgetState extends State<HomeCopyWidget>
    with TickerProviderStateMixin {
  late HomeCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeCopyModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 5,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            decoration: const BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1.0, 0.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.15,
                    decoration: const BoxDecoration(),
                    child: wrapWithModel(
                      model: _model.navProfileButtonModel,
                      updateCallback: () => safeSetState(() {}),
                      child: const NavProfileButtonWidget(),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.6,
                    decoration: const BoxDecoration(),
                    child: Text(
                      '',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).primary,
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(1.0, 0.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.15,
                    decoration: const BoxDecoration(),
                    child: wrapWithModel(
                      model: _model.navPlusButtonModel,
                      updateCallback: () => safeSetState(() {}),
                      child: const NavPlusButtonWidget(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          wrapWithModel(
                            model: _model.journeyageViewModel,
                            updateCallback: () => safeSetState(() {}),
                            child: const JourneyageViewWidget(),
                          ),
                          wrapWithModel(
                            model: _model.communityViewModel,
                            updateCallback: () => safeSetState(() {}),
                            child: const CommunityViewWidget(),
                          ),
                          wrapWithModel(
                            model: _model.feedViewModel,
                            updateCallback: () => safeSetState(() {}),
                            child: const FeedViewWidget(),
                          ),
                          wrapWithModel(
                            model: _model.resourcesViewModel,
                            updateCallback: () => safeSetState(() {}),
                            child: const ResourcesViewWidget(),
                          ),
                          wrapWithModel(
                            model: _model.chatViewModel,
                            updateCallback: () => safeSetState(() {}),
                            child: const ChatViewWidget(),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.0, 0),
                      child: TabBar(
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        labelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 8.0,
                                  letterSpacing: 0.0,
                                ),
                        unselectedLabelStyle: const TextStyle(),
                        indicatorColor: FlutterFlowTheme.of(context).primary,
                        padding: const EdgeInsets.all(2.0),
                        tabs: const [
                          Tab(
                            text: 'PON',
                            icon: Icon(
                              Icons.home_rounded,
                            ),
                          ),
                          Tab(
                            text: 'Community',
                            icon: Icon(
                              Icons.groups,
                            ),
                          ),
                          Tab(
                            text: 'Feed',
                            icon: Icon(
                              Icons.rss_feed_rounded,
                            ),
                          ),
                          Tab(
                            text: 'Resources',
                            icon: Icon(
                              Icons.handshake_rounded,
                            ),
                          ),
                          Tab(
                            text: 'Chat',
                            icon: Icon(
                              Icons.chat_rounded,
                            ),
                          ),
                        ],
                        controller: _model.tabBarController,
                        onTap: (i) async {
                          [
                            () async {},
                            () async {},
                            () async {},
                            () async {},
                            () async {}
                          ][i]();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
