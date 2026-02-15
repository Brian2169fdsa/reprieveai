import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/goals_service.dart';
import '../widgets/goal_card.dart';
import 'create_goal_page.dart';
import 'goal_detail_page.dart';

class GoalsHomePage extends StatefulWidget {
  const GoalsHomePage({super.key});

  @override
  State<GoalsHomePage> createState() => _GoalsHomePageState();
}

class _GoalsHomePageState extends State<GoalsHomePage> {
  final GoalsService _goalsService = GoalsService();
  String _selectedFilter = 'active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

          // Goals list
          Expanded(
            child: StreamBuilder<List<Goal>>(
              stream: _selectedFilter == 'all'
                  ? _goalsService.getGoals()
                  : _goalsService.getGoals(status: _selectedFilter),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading goals',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final goals = snapshot.data ?? [];

                if (goals.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return GoalCard(
                      goal: goal,
                      onTap: () => _navigateToGoalDetail(goal),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreateGoal,
        icon: const Icon(Icons.add),
        label: const Text('New Goal'),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              _selectedFilter == 'active'
                  ? 'No active goals yet'
                  : _selectedFilter == 'completed'
                      ? 'No completed goals yet'
                      : _selectedFilter == 'paused'
                          ? 'No paused goals'
                          : 'No goals yet',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first goal to get started on your journey',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
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
