import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityComment {
  final String commentId;
  final String postId;
  final String userId;
  final String text;
  final DateTime createdAt;
  final String moderationStatus; // 'pending', 'approved', 'rejected'

  CommunityComment({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.text,
    required this.createdAt,
    this.moderationStatus = 'pending',
  });

  factory CommunityComment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommunityComment(
      commentId: doc.id,
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      moderationStatus: data['moderationStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'userId': userId,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'moderationStatus': moderationStatus,
    };
  }
}
