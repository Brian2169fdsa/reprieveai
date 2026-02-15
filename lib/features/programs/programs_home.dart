import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/features/programs/program_card.dart';
import '/features/programs/programs_home_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProgramsHomePage extends StatelessWidget {
  const ProgramsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgramsHomeController(),
      child: Consumer<ProgramsHomeController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              elevation: 0.0,
              title: Text(
                'Programs',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth >= 1000
                    ? 3
                    : constraints.maxWidth >= 700
                        ? 2
                        : 1;

                return GridView.builder(
                  padding: const EdgeInsets.all(20.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: crossAxisCount == 1 ? 3.2 : 2.6,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 12.0,
                  ),
                  itemCount: controller.programs.length,
                  itemBuilder: (context, index) {
                    final item = controller.programs[index];
                    return ProgramCard(
                      title: item.title,
                      subtitle: item.subtitle,
                      icon: item.icon,
                      onTap: () => context.push(item.route),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
