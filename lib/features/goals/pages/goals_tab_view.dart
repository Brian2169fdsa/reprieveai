import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/goals_service.dart';
import '../widgets/goal_card.dart';
import 'create_goal_page.dart';
import 'goal_detail_page.dart';

/// Simplified Goals view for use in TabBarView (without Scaffold/AppBar)
class GoalsTabView extends StatefulWidget {
  const GoalsTabView({super.key});

  @override
  State<GoalsTabView> createState() => _GoalsTabViewState();
}

class _GoalsTabViewState extends State<GoalsTabView> {
  final GoalsService _goalsService = GoalsService();
  String _selectedFilter = 'active';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Header - matches home page style
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              height: 51.0,
              decoration: const BoxDecoration(),
              child: Row(
                children: [
                  Text(
                    'My Goals',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showFilterMenu,
                  ),
                ],
              ),
            ),
          ),

          // Filter chips - matches home page style
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('active', 'Active'),
                    const SizedBox(width: 8),
                    _buildFilterChip('completed', 'Completed'),
                    const SizedBox(width: 8),
                    _buildFilterChip('paused', 'Paused'),
                    const SizedBox(width: 8),
                    _buildFilterChip('all', 'All'),
                  ],
                ),
              ),
            ),
          ),

          // Goals list - matches home page style
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
            child: StreamBuilder<List<Goal>>(
              stream: _selectedFilter == 'all'
                  ? _goalsService.getGoals()
                  : _goalsService.getGoals(status: _selectedFilter),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading goals',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                final goals = snapshot.data ?? [];

                if (goals.isEmpty) {
                  return _buildEmptyState();
                }

                return Column(
                  children: goals.map((goal) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GoalCard(
                        goal: goal,
                        onTap: () => _navigateToGoalDetail(goal),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // Create goal button - matches home page style
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: ElevatedButton.icon(
                onPressed: _navigateToCreateGoal,
                icon: const Icon(Icons.add),
                label: const Text('New Goal'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          // Bottom padding
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = value;
          });
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedFilter == 'active'
                ? 'No active goals yet'
                : _selectedFilter == 'completed'
                    ? 'No completed goals yet'
                    : _selectedFilter == 'paused'
                        ? 'No paused goals'
                        : 'No goals yet',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first goal to get started',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToCreateGoal,
            icon: const Icon(Icons.add),
            label: const Text('Create Goal'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Active Goals'),
                onTap: () {
                  setState(() => _selectedFilter = 'active');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.done_all),
                title: const Text('Completed Goals'),
                onTap: () {
                  setState(() => _selectedFilter = 'completed');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.pause_circle),
                title: const Text('Paused Goals'),
                onTap: () {
                  setState(() => _selectedFilter = 'paused');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('All Goals'),
                onTap: () {
                  setState(() => _selectedFilter = 'all');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToCreateGoal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateGoalPage(),
      ),
    );
  }

  void _navigateToGoalDetail(Goal goal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalDetailPage(goal: goal),
      ),
    );
  }
}
