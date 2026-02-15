import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../models/milestone.dart';
import '../services/goals_service.dart';

class GoalDetailPage extends StatefulWidget {
  const GoalDetailPage({
    super.key,
    required this.goal,
  });

  final Goal goal;

  @override
  State<GoalDetailPage> createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  final GoalsService _goalsService = GoalsService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Details'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              if (widget.goal.status == 'active')
                const PopupMenuItem(
                  value: 'pause',
                  child: Row(
                    children: [
                      Icon(Icons.pause),
                      SizedBox(width: 8),
                      Text('Pause'),
                    ],
                  ),
                ),
              if (widget.goal.status == 'paused')
                const PopupMenuItem(
                  value: 'resume',
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(width: 8),
                      Text('Resume'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.archive),
                    SizedBox(width: 8),
                    Text('Archive'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: _handleMenuAction,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Goal header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getCategoryLabel(widget.goal.category),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const Spacer(),
                      _buildStatusBadge(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.goal.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.goal.description != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.goal.description!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (widget.goal.currentStreak > 0) ...[
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.goal.currentStreak} day streak',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 16),
                      ],
                      Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.goal.completionRate.toInt()}% complete',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: widget.goal.completionRate / 100,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    color: theme.colorScheme.primary,
                  ),
                  if (widget.goal.targetDate != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Target: ${_formatDate(widget.goal.targetDate!)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Milestones section
          Row(
            children: [
              Text(
                'Milestones',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _addMilestone,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          StreamBuilder<List<Milestone>>(
            stream: _goalsService.getMilestones(widget.goal.goalId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final milestones = snapshot.data ?? [];

              if (milestones.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 48,
                          color: theme.colorScheme.secondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No milestones yet',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add milestones to track your progress',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children:
                    milestones.map((m) => _buildMilestoneCard(m)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(Milestone milestone) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: milestone.isCompleted,
          onChanged: milestone.isCompleted
              ? null
              : (value) => _completeMilestone(milestone),
        ),
        title: Text(
          milestone.title,
          style: TextStyle(
            decoration:
                milestone.isCompleted ? TextDecoration.lineThrough : null,
            color: milestone.isCompleted
                ? theme.colorScheme.secondary
                : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: milestone.description != null
            ? Text(milestone.description!)
            : milestone.isCompleted
                ? Text(
                    'Completed ${_formatDate(milestone.completedAt!)}',
                    style: theme.textTheme.bodySmall,
                  )
                : null,
        trailing: milestone.isCompleted
            ? Icon(Icons.emoji_events, color: Colors.amber)
            : PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) => _handleMilestoneAction(value, milestone),
              ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final color = _getStatusColor(widget.goal.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        widget.goal.status.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  void _handleMenuAction(String action) async {
    switch (action) {
      case 'edit':
        // TODO: Navigate to edit page
        break;
      case 'pause':
        await _goalsService.updateGoal(
          widget.goal.copyWith(status: 'paused'),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Goal paused')),
          );
        }
        break;
      case 'resume':
        await _goalsService.updateGoal(
          widget.goal.copyWith(status: 'active'),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Goal resumed')),
          );
        }
        break;
      case 'archive':
        await _goalsService.archiveGoal(widget.goal.goalId);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Goal archived')),
          );
        }
        break;
      case 'delete':
        final confirmed = await _confirmDelete();
        if (confirmed) {
          await _goalsService.deleteGoal(widget.goal.goalId);
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Goal deleted')),
            );
          }
        }
        break;
    }
  }

  Future<bool> _confirmDelete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal?'),
        content: const Text(
          'This will permanently delete this goal and all its milestones. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _handleMilestoneAction(String action, Milestone milestone) async {
    switch (action) {
      case 'edit':
        // TODO: Edit milestone
        break;
      case 'delete':
        await _goalsService.deleteMilestone(
          milestone.goalId,
          milestone.milestoneId,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Milestone deleted')),
          );
        }
        break;
    }
  }

  Future<void> _completeMilestone(Milestone milestone) async {
    await _goalsService.completeMilestone(
      milestone.goalId,
      milestone.milestoneId,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.celebration, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Milestone completed! You earned 10 credits.'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _addMilestone() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final descriptionController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Milestone'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  // Get current count for order
                  final milestones = await _goalsService
                      .getMilestones(widget.goal.goalId)
                      .first;

                  final milestone = Milestone(
                    milestoneId: '',
                    goalId: widget.goal.goalId,
                    userId: _goalsService.userId!,
                    title: titleController.text,
                    description: descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                    order: milestones.length,
                    visibility: widget.goal.visibility.level,
                    createdAt: DateTime.now(),
                  );

                  await _goalsService.createMilestone(milestone);
                  Navigator.pop(context);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Milestone added')),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
