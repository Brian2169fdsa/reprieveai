import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/features/programs/program_card.dart';
import '/features/programs/programs_home_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Tab-friendly version of ProgramsHomePage without Scaffold
class ProgramsTabView extends StatelessWidget {
  const ProgramsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgramsHomeController(),
      child: Consumer<ProgramsHomeController>(
        builder: (context, controller, _) {
          return Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
                child: Row(
                  children: [
                    Text(
                      'Programs',
                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                            fontFamily: 'Outfit',
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),

              // Programs grid
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth >= 1000
                        ? 3
                        : constraints.maxWidth >= 700
                            ? 2
                            : 1;

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
