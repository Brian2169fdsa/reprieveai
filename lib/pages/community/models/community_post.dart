import 'package:cloud_firestore/cloud_firestore.dart';

enum PostType {
  progress,
  milestone,
  reflection,
  gratitude,
  needRequest,
}

enum PostVisibility {
  public,
  sponsorOnly,
  private,
}

class CommunityPost {
  final String postId;
  final String userId;
  final PostType type;
  final String text;
  final String? linkedGoalId;
  final PostVisibility visibility;
  final DateTime createdAt;
  final String moderationStatus; // 'pending', 'approved', 'rejected'
  final int reactionCount;
  final int commentCount;

  CommunityPost({
    required this.postId,
    required this.userId,
    required this.type,
    required this.text,
    this.linkedGoalId,
    required this.visibility,
    required this.createdAt,
    this.moderationStatus = 'pending',
    this.reactionCount = 0,
    this.commentCount = 0,
  });

  factory CommunityPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommunityPost(
      postId: doc.id,
      userId: data['userId'] ?? '',
      type: _postTypeFromString(data['type'] ?? 'progress'),
      text: data['text'] ?? '',
      linkedGoalId: data['linkedGoalId'],
      visibility: _visibilityFromString(data['visibility'] ?? 'public'),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      moderationStatus: data['moderationStatus'] ?? 'pending',
      reactionCount: data['reactionCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type.name,
      'text': text,
      'linkedGoalId': linkedGoalId,
      'visibility': visibility.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'moderationStatus': moderationStatus,
      'reactionCount': reactionCount,
      'commentCount': commentCount,
    };
  }

  static PostType _postTypeFromString(String type) {
    switch (type) {
      case 'progress':
        return PostType.progress;
      case 'milestone':
        return PostType.milestone;
      case 'reflection':
        return PostType.reflection;
      case 'gratitude':
        return PostType.gratitude;
      case 'needRequest':
        return PostType.needRequest;
      default:
        return PostType.progress;
    }
  }

  static PostVisibility _visibilityFromString(String visibility) {
    switch (visibility) {
      case 'public':
        return PostVisibility.public;
      case 'sponsorOnly':
        return PostVisibility.sponsorOnly;
      case 'private':
        return PostVisibility.private;
      default:
        return PostVisibility.public;
    }
  }

  static String postTypeDisplayName(PostType type) {
    switch (type) {
      case PostType.progress:
        return 'Progress Update';
      case PostType.milestone:
        return 'Milestone';
      case PostType.reflection:
        return 'Reflection';
      case PostType.gratitude:
        return 'Gratitude';
      case PostType.needRequest:
        return 'Need/Request';
    }
  }

  static String visibilityDisplayName(PostVisibility visibility) {
    switch (visibility) {
      case PostVisibility.public:
        return 'Public';
      case PostVisibility.sponsorOnly:
        return 'Sponsor Only';
      case PostVisibility.private:
        return 'Private';
    }
  }
}
