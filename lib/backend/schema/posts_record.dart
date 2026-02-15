import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PostsRecord extends FirestoreRecord {
  PostsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  // "source" field.
  String? _source;
  String get source => _source ?? '';
  bool hasSource() => _source != null;

  // "ownerId" field.
  String? _ownerId;
  String get ownerId => _ownerId ?? '';
  bool hasOwnerId() => _ownerId != null;

  // "replyTo" field.
  String? _replyTo;
  String get replyTo => _replyTo ?? '';
  bool hasReplyTo() => _replyTo != null;

  // "archived" field.
  bool? _archived;
  bool get archived => _archived ?? false;
  bool hasArchived() => _archived != null;

  // "authorDisplayName" field.
  String? _authorDisplayName;
  String get authorDisplayName => _authorDisplayName ?? '';
  bool hasAuthorDisplayName() => _authorDisplayName != null;

  // "authorId" field.
  String? _authorId;
  String get authorId => _authorId ?? '';
  bool hasAuthorId() => _authorId != null;

  // "dev" field.
  bool? _dev;
  bool get dev => _dev ?? false;
  bool hasDev() => _dev != null;

  // "isReply" field.
  bool? _isReply;
  bool get isReply => _isReply ?? false;
  bool hasIsReply() => _isReply != null;

  // "likedBy" field.
  List<String>? _likedBy;
  List<String> get likedBy => _likedBy ?? const [];
  bool hasLikedBy() => _likedBy != null;

  // "media" field.
  List<MediaItemStruct>? _media;
  List<MediaItemStruct> get media => _media ?? const [];
  bool hasMedia() => _media != null;

  // "messageboardLink" field.
  String? _messageboardLink;
  String get messageboardLink => _messageboardLink ?? '';
  bool hasMessageboardLink() => _messageboardLink != null;

  // "replies" field.
  List<String>? _replies;
  List<String> get replies => _replies ?? const [];
  bool hasReplies() => _replies != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  bool hasText() => _text != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  // "authorProfilePicURL" field.
  String? _authorProfilePicURL;
  String get authorProfilePicURL => _authorProfilePicURL ?? '';
  bool hasAuthorProfilePicURL() => _authorProfilePicURL != null;

  void _initializeFields() {
    _id = snapshotData['id'] as String?;
    _source = snapshotData['source'] as String?;
    _ownerId = snapshotData['ownerId'] as String?;
    _replyTo = snapshotData['replyTo'] as String?;
    _archived = snapshotData['archived'] as bool?;
    _authorDisplayName = snapshotData['authorDisplayName'] as String?;
    _authorId = snapshotData['authorId'] as String?;
    _dev = snapshotData['dev'] as bool?;
    _isReply = snapshotData['isReply'] as bool?;
    _likedBy = getDataList(snapshotData['likedBy']);
    _media = getStructList(
      snapshotData['media'],
      MediaItemStruct.fromMap,
    );
    _messageboardLink = snapshotData['messageboardLink'] as String?;
    _replies = getDataList(snapshotData['replies']);
    _text = snapshotData['text'] as String?;
    _title = snapshotData['title'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
    _authorProfilePicURL = snapshotData['authorProfilePicURL'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('posts');

  static Stream<PostsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PostsRecord.fromSnapshot(s));

  static Future<PostsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PostsRecord.fromSnapshot(s));

  static PostsRecord fromSnapshot(DocumentSnapshot snapshot) => PostsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PostsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PostsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PostsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PostsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPostsRecordData({
  String? id,
  String? source,
  String? ownerId,
  String? replyTo,
  bool? archived,
  String? authorDisplayName,
  String? authorId,
  bool? dev,
  bool? isReply,
  String? messageboardLink,
  String? text,
  String? title,
  DateTime? createdAt,
  DateTime? updatedAt,
  String? authorProfilePicURL,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'id': id,
      'source': source,
      'ownerId': ownerId,
      'replyTo': replyTo,
      'archived': archived,
      'authorDisplayName': authorDisplayName,
      'authorId': authorId,
      'dev': dev,
      'isReply': isReply,
      'messageboardLink': messageboardLink,
      'text': text,
      'title': title,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'authorProfilePicURL': authorProfilePicURL,
    }.withoutNulls,
  );

  return firestoreData;
}

class PostsRecordDocumentEquality implements Equality<PostsRecord> {
  const PostsRecordDocumentEquality();

  @override
  bool equals(PostsRecord? e1, PostsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.id == e2?.id &&
        e1?.source == e2?.source &&
        e1?.ownerId == e2?.ownerId &&
        e1?.replyTo == e2?.replyTo &&
        e1?.archived == e2?.archived &&
        e1?.authorDisplayName == e2?.authorDisplayName &&
        e1?.authorId == e2?.authorId &&
        e1?.dev == e2?.dev &&
        e1?.isReply == e2?.isReply &&
        listEquality.equals(e1?.likedBy, e2?.likedBy) &&
        listEquality.equals(e1?.media, e2?.media) &&
        e1?.messageboardLink == e2?.messageboardLink &&
        listEquality.equals(e1?.replies, e2?.replies) &&
        e1?.text == e2?.text &&
        e1?.title == e2?.title &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt &&
        e1?.authorProfilePicURL == e2?.authorProfilePicURL;
  }

  @override
  int hash(PostsRecord? e) => const ListEquality().hash([
        e?.id,
        e?.source,
        e?.ownerId,
        e?.replyTo,
        e?.archived,
        e?.authorDisplayName,
        e?.authorId,
        e?.dev,
        e?.isReply,
        e?.likedBy,
        e?.media,
        e?.messageboardLink,
        e?.replies,
        e?.text,
        e?.title,
        e?.createdAt,
        e?.updatedAt,
        e?.authorProfilePicURL
      ]);

  @override
  bool isValidKey(Object? o) => o is PostsRecord;
}
