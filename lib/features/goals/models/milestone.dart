import 'package:cloud_firestore/cloud_firestore.dart';

class Milestone {
  final String milestoneId;
  final String goalId;
  final String userId;
  final String title;
  final String? description;
  final int order;
  final bool isCompleted;
  final DateTime? completedAt;
  final String visibility;
  final String? celebrationNote;
  final DateTime createdAt;

  Milestone({
    required this.milestoneId,
    required this.goalId,
    required this.userId,
    required this.title,
    this.description,
    required this.order,
    this.isCompleted = false,
    this.completedAt,
    required this.visibility,
    this.celebrationNote,
    required this.createdAt,
  });

  factory Milestone.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Milestone(
      milestoneId: doc.id,
      goalId: data['goalId'] ?? '',
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      order: data['order'] ?? 0,
      isCompleted: data['isCompleted'] ?? false,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      visibility: data['visibility'] ?? 'private',
      celebrationNote: data['celebrationNote'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'milestoneId': milestoneId,
      'goalId': goalId,
      'userId': userId,
      'title': title,
      'description': description,
      'order': order,
      'isCompleted': isCompleted,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'visibility': visibility,
      'celebrationNote': celebrationNote,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Milestone copyWith({
    String? title,
    String? description,
    int? order,
    bool? isCompleted,
    DateTime? completedAt,
    String? visibility,
    String? celebrationNote,
  }) {
    return Milestone(
      milestoneId: milestoneId,
      goalId: goalId,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      visibility: visibility ?? this.visibility,
      celebrationNote: celebrationNote ?? this.celebrationNote,
      createdAt: createdAt,
    );
  }
}
