import 'package:cloud_firestore/cloud_firestore.dart';

enum GoalCategory {
  recovery,
  identityLegal,
  employment,
  housing,
  health,
  community,
  personalGrowth,
}

enum GoalType {
  milestone,
  continuous,
  oneTime,
}

class Goal {
  final String goalId;
  final String userId;
  final String title;
  final String? description;
  final GoalCategory category;
  final GoalType type;
  final String status; // 'active', 'paused', 'completed', 'archived'
  final DateTime? targetDate;
  final DateTime? startDate;
  final DateTime? completedAt;
  final int currentStreak;
  final double completionRate;
  final GoalVisibility visibility;
  final String? linkedNeedId;
  final String? aiSummary;
  final DateTime createdAt;
  final DateTime updatedAt;

  Goal({
    required this.goalId,
    required this.userId,
    required this.title,
    this.description,
    required this.category,
    required this.type,
    required this.status,
    this.targetDate,
    this.startDate,
    this.completedAt,
    this.currentStreak = 0,
    this.completionRate = 0,
    required this.visibility,
    this.linkedNeedId,
    this.aiSummary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Goal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Goal(
      goalId: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      category: _categoryFromString(data['category'] ?? 'recovery'),
      type: _typeFromString(data['type'] ?? 'milestone'),
      status: data['status'] ?? 'active',
      targetDate: data['targetDate'] != null
          ? (data['targetDate'] as Timestamp).toDate()
          : null,
      startDate: data['startDate'] != null
          ? (data['startDate'] as Timestamp).toDate()
          : null,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      currentStreak: data['currentStreak'] ?? 0,
      completionRate: (data['completionRate'] ?? 0).toDouble(),
      visibility: GoalVisibility.fromMap(data['visibility'] ?? {}),
      linkedNeedId: data['linkedNeedId'],
      aiSummary: data['aiSummary'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'goalId': goalId,
      'userId': userId,
      'title': title,
      'description': description,
      'category': category.name,
      'type': type.name,
      'status': status,
      'targetDate': targetDate != null ? Timestamp.fromDate(targetDate!) : null,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'currentStreak': currentStreak,
      'completionRate': completionRate,
      'visibility': visibility.toMap(),
      'linkedNeedId': linkedNeedId,
      'aiSummary': aiSummary,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static GoalCategory _categoryFromString(String category) {
    switch (category) {
      case 'recovery':
        return GoalCategory.recovery;
      case 'identityLegal':
        return GoalCategory.identityLegal;
      case 'employment':
        return GoalCategory.employment;
      case 'housing':
        return GoalCategory.housing;
      case 'health':
        return GoalCategory.health;
      case 'community':
        return GoalCategory.community;
      case 'personalGrowth':
        return GoalCategory.personalGrowth;
      default:
        return GoalCategory.recovery;
    }
  }

  static GoalType _typeFromString(String type) {
    switch (type) {
      case 'milestone':
        return GoalType.milestone;
      case 'continuous':
        return GoalType.continuous;
      case 'oneTime':
        return GoalType.oneTime;
      default:
        return GoalType.milestone;
    }
  }

  Goal copyWith({
    String? title,
    String? description,
    GoalCategory? category,
    GoalType? type,
    String? status,
    DateTime? targetDate,
    DateTime? startDate,
    DateTime? completedAt,
    int? currentStreak,
    double? completionRate,
    GoalVisibility? visibility,
    String? linkedNeedId,
    String? aiSummary,
  }) {
    return Goal(
      goalId: goalId,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      status: status ?? this.status,
      targetDate: targetDate ?? this.targetDate,
      startDate: startDate ?? this.startDate,
      completedAt: completedAt ?? this.completedAt,
      currentStreak: currentStreak ?? this.currentStreak,
      completionRate: completionRate ?? this.completionRate,
      visibility: visibility ?? this.visibility,
      linkedNeedId: linkedNeedId ?? this.linkedNeedId,
      aiSummary: aiSummary ?? this.aiSummary,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class GoalVisibility {
  final String level; // 'private', 'sponsor_only', 'public_milestone'
  final bool sponsorCanComment;

  GoalVisibility({
    required this.level,
    required this.sponsorCanComment,
  });

  factory GoalVisibility.fromMap(Map<String, dynamic> map) {
    return GoalVisibility(
      level: map['level'] ?? 'private',
      sponsorCanComment: map['sponsorCanComment'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'sponsorCanComment': sponsorCanComment,
    };
  }
}
