import 'package:flutter/material.dart';

class ProgramItem {
  const ProgramItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
}

class ProgramsHomeController extends ChangeNotifier {
  final List<ProgramItem> programs = const [
    ProgramItem(
      title: 'Position of Neutrality',
      subtitle: 'Core recovery foundation and daily practice.',
      icon: Icons.self_improvement_rounded,
      route: '/programs/pon',
    ),
    ProgramItem(
      title: 'Vocational Programs',
      subtitle: 'Build workforce readiness and job placement skills.',
      icon: Icons.work_outline_rounded,
      route: '/programs/vocational',
    ),
    ProgramItem(
      title: 'Intensive Outpatient (IOP)',
      subtitle: 'Structured support for higher-acuity recovery needs.',
      icon: Icons.local_hospital_outlined,
      route: '/programs/iop',
    ),
    ProgramItem(
      title: 'Reentry Planning',
      subtitle: 'Plan housing, employment, and continuity of care.',
      icon: Icons.assignment_turned_in_outlined,
      route: '/programs/reentry',
    ),
    ProgramItem(
      title: 'Resource Navigator (AI)',
      subtitle: 'Find support services and community resources quickly.',
      icon: Icons.assistant_rounded,
      route: '/programs/resources',
    ),
    ProgramItem(
      title: 'Peer Support / Sponsor Matching',
      subtitle: 'Connect with peers and identify sponsor opportunities.',
      icon: Icons.groups_2_outlined,
      route: '/programs/peer',
    ),
  ];
}
