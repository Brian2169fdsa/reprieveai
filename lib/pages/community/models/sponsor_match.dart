import 'package:cloud_firestore/cloud_firestore.dart';

class SponsorMatch {
  final String participantId;
  final String sponsorId;

  SponsorMatch({
    required this.participantId,
    required this.sponsorId,
  });

  factory SponsorMatch.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SponsorMatch(
      participantId: data['participantId'] ?? '',
      sponsorId: data['sponsorId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'participantId': participantId,
      'sponsorId': sponsorId,
    };
  }
}
