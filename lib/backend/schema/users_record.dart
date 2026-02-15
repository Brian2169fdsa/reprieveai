import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  // "ownerId" field.
  String? _ownerId;
  String get ownerId => _ownerId ?? '';
  bool hasOwnerId() => _ownerId != null;

  // "allowPhoneContact" field.
  bool? _allowPhoneContact;
  bool get allowPhoneContact => _allowPhoneContact ?? false;
  bool hasAllowPhoneContact() => _allowPhoneContact != null;

  // "anonymous" field.
  bool? _anonymous;
  bool get anonymous => _anonymous ?? false;
  bool hasAnonymous() => _anonymous != null;

  // "archived" field.
  bool? _archived;
  bool get archived => _archived ?? false;
  bool hasArchived() => _archived != null;

  // "blockedUsers" field.
  List<String>? _blockedUsers;
  List<String> get blockedUsers => _blockedUsers ?? const [];
  bool hasBlockedUsers() => _blockedUsers != null;

  // "dev" field.
  bool? _dev;
  bool get dev => _dev ?? false;
  bool hasDev() => _dev != null;

  // "displayName" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "firstName" field.
  String? _firstName;
  String get firstName => _firstName ?? '';
  bool hasFirstName() => _firstName != null;

  // "lastName" field.
  String? _lastName;
  String get lastName => _lastName ?? '';
  bool hasLastName() => _lastName != null;

  // "likeCount" field.
  int? _likeCount;
  int get likeCount => _likeCount ?? 0;
  bool hasLikeCount() => _likeCount != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  bool hasPhone() => _phone != null;

  // "profilePicURL" field.
  String? _profilePicURL;
  String get profilePicURL => _profilePicURL ?? '';
  bool hasProfilePicURL() => _profilePicURL != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  bool hasRole() => _role != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _id = snapshotData['id'] as String?;
    _ownerId = snapshotData['ownerId'] as String?;
    _allowPhoneContact = snapshotData['allowPhoneContact'] as bool?;
    _anonymous = snapshotData['anonymous'] as bool?;
    _archived = snapshotData['archived'] as bool?;
    _blockedUsers = getDataList(snapshotData['blockedUsers']);
    _dev = snapshotData['dev'] as bool?;
    _displayName = snapshotData['displayName'] as String?;
    _firstName = snapshotData['firstName'] as String?;
    _lastName = snapshotData['lastName'] as String?;
    _likeCount = castToType<int>(snapshotData['likeCount']);
    _phone = snapshotData['phone'] as String?;
    _profilePicURL = snapshotData['profilePicURL'] as String?;
    _role = snapshotData['role'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? id,
  String? ownerId,
  bool? allowPhoneContact,
  bool? anonymous,
  bool? archived,
  bool? dev,
  String? displayName,
  String? firstName,
  String? lastName,
  int? likeCount,
  String? phone,
  String? profilePicURL,
  String? role,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'id': id,
      'ownerId': ownerId,
      'allowPhoneContact': allowPhoneContact,
      'anonymous': anonymous,
      'archived': archived,
      'dev': dev,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'likeCount': likeCount,
      'phone': phone,
      'profilePicURL': profilePicURL,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.id == e2?.id &&
        e1?.ownerId == e2?.ownerId &&
        e1?.allowPhoneContact == e2?.allowPhoneContact &&
        e1?.anonymous == e2?.anonymous &&
        e1?.archived == e2?.archived &&
        listEquality.equals(e1?.blockedUsers, e2?.blockedUsers) &&
        e1?.dev == e2?.dev &&
        e1?.displayName == e2?.displayName &&
        e1?.firstName == e2?.firstName &&
        e1?.lastName == e2?.lastName &&
        e1?.likeCount == e2?.likeCount &&
        e1?.phone == e2?.phone &&
        e1?.profilePicURL == e2?.profilePicURL &&
        e1?.role == e2?.role &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.id,
        e?.ownerId,
        e?.allowPhoneContact,
        e?.anonymous,
        e?.archived,
        e?.blockedUsers,
        e?.dev,
        e?.displayName,
        e?.firstName,
        e?.lastName,
        e?.likeCount,
        e?.phone,
        e?.profilePicURL,
        e?.role,
        e?.createdAt,
        e?.updatedAt
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
