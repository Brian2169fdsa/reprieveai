import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/goal.dart';
import '../models/milestone.dart';

class GoalsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  // Goals CRUD Operations

  Future<String> createGoal(Goal goal) async {
    if (userId == null) throw Exception('User not authenticated');

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc();

    final goalWithId = Goal(
      goalId: docRef.id,
      userId: userId!,
      title: goal.title,
      description: goal.description,
      category: goal.category,
      type: goal.type,
      status: 'active',
      targetDate: goal.targetDate,
      startDate: DateTime.now(),
      visibility: goal.visibility,
      linkedNeedId: goal.linkedNeedId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await docRef.set(goalWithId.toFirestore());
    return docRef.id;
  }

  Future<void> updateGoal(Goal goal) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goal.goalId)
        .update(goal.toFirestore());
  }

  Future<void> deleteGoal(String goalId) async {
    if (userId == null) throw Exception('User not authenticated');

    // Delete all milestones first
    final milestones = await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .collection('milestones')
        .get();

    final batch = _firestore.batch();
    for (var doc in milestones.docs) {
      batch.delete(doc.reference);
    }

    // Delete the goal
    batch.delete(_firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId));

    await batch.commit();
  }

  Stream<List<Goal>> getGoals({String? status}) {
    if (userId == null) return Stream.value([]);

    Query query = _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .orderBy('createdAt', descending: true);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Goal.fromFirestore(doc)).toList();
    });
  }

  Future<Goal?> getGoal(String goalId) async {
    if (userId == null) return null;

    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .get();

    if (!doc.exists) return null;
    return Goal.fromFirestore(doc);
  }

  Future<void> archiveGoal(String goalId) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .update({
      'status': 'archived',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> completeGoal(String goalId) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .update({
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Milestones CRUD Operations

  Future<String> createMilestone(Milestone milestone) async {
    if (userId == null) throw Exception('User not authenticated');

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(milestone.goalId)
        .collection('milestones')
        .doc();

    final milestoneWithId = Milestone(
      milestoneId: docRef.id,
      goalId: milestone.goalId,
      userId: userId!,
      title: milestone.title,
      description: milestone.description,
      order: milestone.order,
      visibility: milestone.visibility,
      createdAt: DateTime.now(),
    );

    await docRef.set(milestoneWithId.toFirestore());
    return docRef.id;
  }

  Future<void> updateMilestone(Milestone milestone) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(milestone.goalId)
        .collection('milestones')
        .doc(milestone.milestoneId)
        .update(milestone.toFirestore());
  }

  Future<void> completeMilestone(String goalId, String milestoneId,
      {String? celebrationNote}) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .collection('milestones')
        .doc(milestoneId)
        .update({
      'isCompleted': true,
      'completedAt': FieldValue.serverTimestamp(),
      'celebrationNote': celebrationNote,
    });

    // Update goal completion rate
    await _updateGoalCompletionRate(goalId);
  }

  Future<void> deleteMilestone(String goalId, String milestoneId) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .collection('milestones')
        .doc(milestoneId)
        .delete();

    // Update goal completion rate
    await _updateGoalCompletionRate(goalId);
  }

  Stream<List<Milestone>> getMilestones(String goalId) {
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .collection('milestones')
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Milestone.fromFirestore(doc))
          .toList();
    });
  }

  // Helper Methods

  Future<void> _updateGoalCompletionRate(String goalId) async {
    if (userId == null) return;

    final milestones = await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .collection('milestones')
        .get();

    if (milestones.docs.isEmpty) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc(goalId)
          .update({'completionRate': 0});
      return;
    }

    final completed = milestones.docs
        .where((doc) => doc.data()['isCompleted'] == true)
        .length;

    final completionRate = (completed / milestones.docs.length) * 100;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .update({
      'completionRate': completionRate,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // If all milestones completed, mark goal as complete
    if (completionRate == 100) {
      await completeGoal(goalId);
    }
  }

  Future<void> createGoalWithMilestones(
    Goal goal,
    List<String> milestonesTitles,
  ) async {
    final goalId = await createGoal(goal);

    final batch = _firestore.batch();

    for (int i = 0; i < milestonesTitles.length; i++) {
      final milestoneRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc(goalId)
          .collection('milestones')
          .doc();

      final milestone = Milestone(
        milestoneId: milestoneRef.id,
        goalId: goalId,
        userId: userId!,
        title: milestonesTitles[i],
        order: i,
        visibility: goal.visibility.level,
        createdAt: DateTime.now(),
      );

      batch.set(milestoneRef, milestone.toFirestore());
    }

    await batch.commit();
  }
}
