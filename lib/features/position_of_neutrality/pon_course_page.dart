import 'package:flutter/material.dart';

import 'widgets/course_video_card.dart';

class PonCoursePage extends StatelessWidget {
  const PonCoursePage({super.key});

  static const List<_PonCourseVideo> _videos = [
    _PonCourseVideo(
      videoId: 'yJs6CCiwKIs',
      title: 'Movement',
      stepLabel: 'Introduction',
      description:
          'An overview of the Position of Neutrality movement and the purpose behind this recovery path.',
    ),
    _PonCourseVideo(
      videoId: 'QrqNO_TIOYk',
      title: 'The Question',
      stepLabel: 'Foundation',
      description:
          'A core framing question to prepare your mindset and help you engage the full program intentionally.',
    ),
    _PonCourseVideo(
      videoId: 'T8nHLJ9nqSg',
      title: 'Course 1: Concession',
      stepLabel: 'Step 1',
      description:
          'Explore surrender, acceptance, and the first practical commitments that create momentum in recovery.',
    ),
    _PonCourseVideo(
      videoId: 'mhAm_BmlWdM',
      title: 'Course 2: Encounter',
      stepLabel: 'Step 2',
      description:
          'Develop awareness of personal patterns, emotional triggers, and moments where change can begin.',
    ),
    _PonCourseVideo(
      videoId: 'IHQAAcv1i1I',
      title: 'Course 3: Decision',
      stepLabel: 'Step 3',
      description:
          'Make a focused, values-based decision and define the daily actions that support spiritual alignment.',
    ),
    _PonCourseVideo(
      videoId: 'xD4fybJpZuM',
      title: 'Course 4: Introspection',
      stepLabel: 'Step 4',
      description:
          'Learn reflection practices for honest self-inventory and identifying barriers to progress.',
    ),
    _PonCourseVideo(
      videoId: '4eHsi-5FKBw',
      title: 'Course 5: Repentance & Rededication',
      stepLabel: 'Steps 5–7',
      description:
          'Apply confession, accountability, and renewed intention to stabilize your recovery walk.',
    ),
    _PonCourseVideo(
      videoId: 'yZ3bTZCeFdU',
      title: 'Course 6: Spiritual Fitness',
      stepLabel: 'Steps 8–9',
      description:
          'Build sustainable spiritual routines and reconciliation habits for long-term health and growth.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Position of Neutrality'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 768;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                  child: isWide ? _buildGrid() : _buildColumn(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 1.15,
      ),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final video = _videos[index];
        return CourseVideoCard(
          videoId: video.videoId,
          title: video.title,
          stepLabel: video.stepLabel,
          description: video.description,
        );
      },
    );
  }

  Widget _buildColumn() {
    return Column(
      children: _videos
          .map(
            (video) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: CourseVideoCard(
                videoId: video.videoId,
                title: video.title,
                stepLabel: video.stepLabel,
                description: video.description,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PonCourseVideo {
  const _PonCourseVideo({
    required this.videoId,
    required this.title,
    required this.stepLabel,
    required this.description,
  });

  final String videoId;
  final String title;
  final String stepLabel;
  final String description;
}
