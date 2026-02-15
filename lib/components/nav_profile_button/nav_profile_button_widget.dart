import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'nav_profile_button_model.dart';
export 'nav_profile_button_model.dart';

class NavProfileButtonWidget extends StatefulWidget {
  const NavProfileButtonWidget({super.key});

  @override
  State<NavProfileButtonWidget> createState() => _NavProfileButtonWidgetState();
}

class _NavProfileButtonWidgetState extends State<NavProfileButtonWidget> {
  late NavProfileButtonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavProfileButtonModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterFlowIconButton(
      borderColor: Colors.transparent,
      borderRadius: 30.0,
      buttonSize: 46.0,
      icon: Icon(
        Icons.person_rounded,
        color: FlutterFlowTheme.of(context).primary,
        size: 40.0,
      ),
      onPressed: () async {
        context.pushNamed('Profile');
      },
    );
  }
}
