import 'package:flutter/material.dart';
import 'web_youtube_player_stub.dart'
    if (dart.library.html) 'web_youtube_player_web.dart';

class CourseVideoCard extends StatefulWidget {
  const CourseVideoCard({
    super.key,
    required this.videoId,
    required this.title,
    required this.stepLabel,
    required this.description,
  });

  final String videoId;
  final String title;
  final String stepLabel;
  final String description;

  @override
  State<CourseVideoCard> createState() => _CourseVideoCardState();
}

class _CourseVideoCardState extends State<CourseVideoCard> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact = MediaQuery.of(context).size.width < 600;

    return Card(
      color: Colors.white,
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _isPlaying
                ? WebYoutubePlayer(videoId: widget.videoId)
                : InkWell(
                    onTap: () {
                      setState(() {
                        _isPlaying = true;
                      });
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://img.youtube.com/vi/${widget.videoId}/hqdefault.jpg',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 64,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.35),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade700,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isCompact ? 'Watch' : 'Watch Video',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.stepLabel,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
