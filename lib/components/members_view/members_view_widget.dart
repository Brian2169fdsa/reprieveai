import '/backend/backend.dart';
import '/components/members_list_item/members_list_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'members_view_model.dart';
export 'members_view_model.dart';

class MembersViewWidget extends StatefulWidget {
  const MembersViewWidget({super.key});

  @override
  State<MembersViewWidget> createState() => _MembersViewWidgetState();
}

class _MembersViewWidgetState extends State<MembersViewWidget> {
  late MembersViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MembersViewModel());

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
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: 80.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
        ),
        PagedListView<DocumentSnapshot<Object?>?, UsersRecord>(
          pagingController: _model.setListViewController(
            UsersRecord.collection
                .where(
                  'dev',
                  isEqualTo: false,
                )
                .where(
                  'archived',
                  isEqualTo: false,
                )
                .orderBy('createdAt', descending: true),
          ),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          reverse: false,
          scrollDirection: Axis.vertical,
          builderDelegate: PagedChildBuilderDelegate<UsersRecord>(
            // Customize what your widget looks like when it's loading the first page.
            firstPageProgressIndicatorBuilder: (_) => Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
            // Customize what your widget looks like when it's loading another page.
            newPageProgressIndicatorBuilder: (_) => Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),

            itemBuilder: (context, _, listViewIndex) {
              final listViewUsersRecord =
                  _model.listViewPagingController!.itemList![listViewIndex];
              return MembersListItemWidget(
                key: Key(
                    'Keyns2_${listViewIndex}_of_${_model.listViewPagingController!.itemList!.length}'),
                displayName: listViewUsersRecord.displayName,
                subtitle: listViewUsersRecord.role,
                imageURL: listViewUsersRecord.profilePicURL,
              );
            },
          ),
        ),
      ],
    );
  }
}
