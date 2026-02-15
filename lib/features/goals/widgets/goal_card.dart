import 'package:flutter/material.dart';
import '../models/goal.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
    this.onTap,
  });

  final Goal goal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and status
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIcon(goal.category),
                          size: 14,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getCategoryLabel(goal.category),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _buildStatusBadge(
                    goal.status,
                    _getStatusColor(goal.status),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Goal title
              Text(
                goal.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              if (goal.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  goal.description!,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 16),

              // Progress and streak
              Row(
                children: [
                  if (goal.currentStreak > 0) ...[
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${goal.currentStreak} day${goal.currentStreak != 1 ? 's' : ''} streak',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                  ],
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${goal.completionRate.toInt()}% complete',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),

              if (goal.completionRate > 0) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: goal.completionRate / 100,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  color: theme.colorScheme.primary,
                ),
              ],

              if (goal.targetDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Due ${_formatDate(goal.targetDate!)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(GoalCategory category) {
    switch (category) {
      case GoalCategory.recovery:
        return Icons.favorite;
      case GoalCategory.identityLegal:
        return Icons.badge;
      case GoalCategory.employment:
        return Icons.work;
      case GoalCategory.housing:
        return Icons.home;
      case GoalCategory.health:
        return Icons.health_and_safety;
      case GoalCategory.community:
        return Icons.people;
      case GoalCategory.personalGrowth:
        return Icons.school;
    }
  }

  String _getCategoryLabel(GoalCategory category) {
    switch (category) {
      case GoalCategory.recovery:
        return 'RECOVERY';
      case GoalCategory.identityLegal:
        return 'IDENTITY';
      case GoalCategory.employment:
        return 'EMPLOYMENT';
      case GoalCategory.housing:
        return 'HOUSING';
      case GoalCategory.health:
        return 'HEALTH';
      case GoalCategory.community:
        return 'COMMUNITY';
      case GoalCategory.personalGrowth:
        return 'GROWTH';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) return 'today';
    if (difference == 1) return 'tomorrow';
    if (difference > 0) return 'in $difference days';
    if (difference == -1) return 'yesterday';
    return '${-difference} days ago';
  }
}
