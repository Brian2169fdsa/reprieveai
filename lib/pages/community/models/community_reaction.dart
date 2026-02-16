import 'package:cloud_firestore/cloud_firestore.dart';

enum ReactionType {
  encouragement,
  support,
  proud,
  respect,
}

class CommunityReaction {
  final String postId;
  final String userId;
  final ReactionType reactionType;

  CommunityReaction({
    required this.postId,
    required this.userId,
    required this.reactionType,
  });

  factory CommunityReaction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommunityReaction(
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      reactionType: _reactionTypeFromString(data['reactionType'] ?? 'encouragement'),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'userId': userId,
      'reactionType': reactionType.name,
    };
  }

  static ReactionType _reactionTypeFromString(String type) {
    switch (type) {
      case 'encouragement':
        return ReactionType.encouragement;
      case 'support':
        return ReactionType.support;
      case 'proud':
        return ReactionType.proud;
      case 'respect':
        return ReactionType.respect;
      default:
        return ReactionType.encouragement;
    }
  }

  static String reactionTypeDisplayName(ReactionType type) {
    switch (type) {
      case ReactionType.encouragement:
        return '💪 Encouragement';
      case ReactionType.support:
        return '🤝 Support';
      case ReactionType.proud:
        return '🌟 Proud';
      case ReactionType.respect:
        return '👏 Respect';
    }
  }

  static String reactionTypeEmoji(ReactionType type) {
    switch (type) {
      case ReactionType.encouragement:
        return '💪';
      case ReactionType.support:
        return '🤝';
      case ReactionType.proud:
        return '🌟';
      case ReactionType.respect:
        return '👏';
    }
  }
}
