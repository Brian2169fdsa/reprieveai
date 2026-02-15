import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../models/goal_template.dart';
import '../services/goals_service.dart';

class CreateGoalPage extends StatefulWidget {
  const CreateGoalPage({super.key});

  @override
  State<CreateGoalPage> createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends State<CreateGoalPage> {
  final GoalsService _goalsService = GoalsService();
  final _formKey = GlobalKey<FormState>();

  bool _showTemplates = true;
  GoalTemplate? _selectedTemplate;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  GoalCategory _selectedCategory = GoalCategory.recovery;
  GoalType _selectedType = GoalType.milestone;
  DateTime? _targetDate;
  List<String> _milestones = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Goal'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showTemplates = !_showTemplates;
              });
            },
            child: Text(_showTemplates ? 'Custom' : 'Templates'),
          ),
        ],
      ),
      body: _showTemplates ? _buildTemplateView() : _buildCustomForm(),
    );
  }

  Widget _buildTemplateView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start with a Template',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a pre-built goal template to get started quickly',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategorySection('Recovery', GoalTemplates.recovery),
              _buildCategorySection(
                  'Identity & Legal', GoalTemplates.identityLegal),
              _buildCategorySection('Employment', GoalTemplates.employment),
              _buildCategorySection('Housing', GoalTemplates.housing),
              _buildCategorySection('Health', GoalTemplates.health),
              _buildCategorySection('Community', GoalTemplates.community),
              _buildCategorySection(
                  'Personal Growth', GoalTemplates.personalGrowth),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(String title, List<GoalTemplate> templates) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...templates.map((template) => _buildTemplateCard(template)).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTemplateCard(GoalTemplate template) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _selectTemplate(template),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                template.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                template.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (template.milestones.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  '${template.milestones.length} milestones',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Goal Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a goal title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<GoalCategory>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: GoalCategory.values
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(_getCategoryLabel(category)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<GoalType>(
            value: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Goal Type',
              border: OutlineInputBorder(),
            ),
            items: GoalType.values
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(_getTypeLabel(type)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedType = value);
              }
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Target Date (optional)'),
            subtitle: _targetDate != null
                ? Text(_targetDate.toString().split(' ')[0])
                : const Text('No target date set'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_targetDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() => _targetDate = null);
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Milestones',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton.icon(
                onPressed: _addMilestone,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
          ..._milestones.asMap().entries.map((entry) {
            final index = entry.key;
            final milestone = entry.value;
            return ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(milestone),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeMilestone(index),
              ),
            );
          }).toList(),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isLoading ? null : _createGoal,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create Goal'),
          ),
        ],
      ),
    );
  }

  void _selectTemplate(GoalTemplate template) {
    setState(() {
      _selectedTemplate = template;
      _titleController.text = template.title;
      _descriptionController.text = template.description;
      _selectedCategory = template.category;
      _selectedType = template.type;
      _milestones = List.from(template.milestones);

      if (template.suggestedDurationDays != null) {
        _targetDate = DateTime.now()
            .add(Duration(days: template.suggestedDurationDays!));
      }

      _showTemplates = false;
    });
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() => _targetDate = date);
    }
  }

  void _addMilestone() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Milestone'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Milestone title',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _milestones.add(controller.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeMilestone(int index) {
    setState(() {
      _milestones.removeAt(index);
    });
  }

  Future<void> _createGoal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final goal = Goal(
        goalId: '',
        userId: _goalsService.userId!,
        title: _titleController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        category: _selectedCategory,
        type: _selectedType,
        status: 'active',
        targetDate: _targetDate,
        visibility: GoalVisibility(
          level: 'private',
          sponsorCanComment: false,
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (_milestones.isNotEmpty) {
        await _goalsService.createGoalWithMilestones(goal, _milestones);
      } else {
        await _goalsService.createGoal(goal);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating goal: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getCategoryLabel(GoalCategory category) {
    switch (category) {
      case GoalCategory.recovery:
        return 'Recovery';
      case GoalCategory.identityLegal:
        return 'Identity & Legal';
      case GoalCategory.employment:
        return 'Employment';
      case GoalCategory.housing:
        return 'Housing';
      case GoalCategory.health:
        return 'Health';
      case GoalCategory.community:
        return 'Community';
      case GoalCategory.personalGrowth:
        return 'Personal Growth';
    }
  }

  String _getTypeLabel(GoalType type) {
    switch (type) {
      case GoalType.milestone:
        return 'Milestone-based';
      case GoalType.continuous:
        return 'Continuous';
      case GoalType.oneTime:
        return 'One-time';
    }
  }
}
