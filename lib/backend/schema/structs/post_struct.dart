// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PostStruct extends FFFirebaseStruct {
  PostStruct({
    String? id,
    String? source,
    String? ownerId,
    String? replyTo,
    bool? archived,
    String? authorDisplayName,
    String? authorId,
    String? authorProfilePicURL,
    bool? dev,
    bool? isReply,
    List<String>? likedBy,
    List<MediaItemStruct>? media,
    String? messageboardLink,
    List<String>? replies,
    String? text,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _source = source,
        _ownerId = ownerId,
        _replyTo = replyTo,
        _archived = archived,
        _authorDisplayName = authorDisplayName,
        _authorId = authorId,
        _authorProfilePicURL = authorProfilePicURL,
        _dev = dev,
        _isReply = isReply,
        _likedBy = likedBy,
        _media = media,
        _messageboardLink = messageboardLink,
        _replies = replies,
        _text = text,
        _title = title,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        super(firestoreUtilData);

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "source" field.
  String? _source;
  String get source => _source ?? '';
  set source(String? val) => _source = val;

  bool hasSource() => _source != null;

  // "ownerId" field.
  String? _ownerId;
  String get ownerId => _ownerId ?? '';
  set ownerId(String? val) => _ownerId = val;

  bool hasOwnerId() => _ownerId != null;

  // "replyTo" field.
  String? _replyTo;
  String get replyTo => _replyTo ?? '';
  set replyTo(String? val) => _replyTo = val;

  bool hasReplyTo() => _replyTo != null;

  // "archived" field.
  bool? _archived;
  bool get archived => _archived ?? false;
  set archived(bool? val) => _archived = val;

  bool hasArchived() => _archived != null;

  // "authorDisplayName" field.
  String? _authorDisplayName;
  String get authorDisplayName => _authorDisplayName ?? '';
  set authorDisplayName(String? val) => _authorDisplayName = val;

  bool hasAuthorDisplayName() => _authorDisplayName != null;

  // "authorId" field.
  String? _authorId;
  String get authorId => _authorId ?? '';
  set authorId(String? val) => _authorId = val;

  bool hasAuthorId() => _authorId != null;

  // "authorProfilePicURL" field.
  String? _authorProfilePicURL;
  String get authorProfilePicURL => _authorProfilePicURL ?? '';
  set authorProfilePicURL(String? val) => _authorProfilePicURL = val;

  bool hasAuthorProfilePicURL() => _authorProfilePicURL != null;

  // "dev" field.
  bool? _dev;
  bool get dev => _dev ?? false;
  set dev(bool? val) => _dev = val;

  bool hasDev() => _dev != null;

  // "isReply" field.
  bool? _isReply;
  bool get isReply => _isReply ?? false;
  set isReply(bool? val) => _isReply = val;

  bool hasIsReply() => _isReply != null;

  // "likedBy" field.
  List<String>? _likedBy;
  List<String> get likedBy => _likedBy ?? const [];
  set likedBy(List<String>? val) => _likedBy = val;

  void updateLikedBy(Function(List<String>) updateFn) {
    updateFn(_likedBy ??= []);
  }

  bool hasLikedBy() => _likedBy != null;

  // "media" field.
  List<MediaItemStruct>? _media;
  List<MediaItemStruct> get media => _media ?? const [];
  set media(List<MediaItemStruct>? val) => _media = val;

  void updateMedia(Function(List<MediaItemStruct>) updateFn) {
    updateFn(_media ??= []);
  }

  bool hasMedia() => _media != null;

  // "messageboardLink" field.
  String? _messageboardLink;
  String get messageboardLink => _messageboardLink ?? '';
  set messageboardLink(String? val) => _messageboardLink = val;

  bool hasMessageboardLink() => _messageboardLink != null;

  // "replies" field.
  List<String>? _replies;
  List<String> get replies => _replies ?? const [];
  set replies(List<String>? val) => _replies = val;

  void updateReplies(Function(List<String>) updateFn) {
    updateFn(_replies ??= []);
  }

  bool hasReplies() => _replies != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;

  bool hasText() => _text != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  set updatedAt(DateTime? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  static PostStruct fromMap(Map<String, dynamic> data) => PostStruct(
        id: data['id'] as String?,
        source: data['source'] as String?,
        ownerId: data['ownerId'] as String?,
        replyTo: data['replyTo'] as String?,
        archived: data['archived'] as bool?,
        authorDisplayName: data['authorDisplayName'] as String?,
        authorId: data['authorId'] as String?,
        authorProfilePicURL: data['authorProfilePicURL'] as String?,
        dev: data['dev'] as bool?,
        isReply: data['isReply'] as bool?,
        likedBy: getDataList(data['likedBy']),
        media: getStructList(
          data['media'],
          MediaItemStruct.fromMap,
        ),
        messageboardLink: data['messageboardLink'] as String?,
        replies: getDataList(data['replies']),
        text: data['text'] as String?,
        title: data['title'] as String?,
        createdAt: data['createdAt'] as DateTime?,
        updatedAt: data['updatedAt'] as DateTime?,
      );

  static PostStruct? maybeFromMap(dynamic data) =>
      data is Map ? PostStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'source': _source,
        'ownerId': _ownerId,
        'replyTo': _replyTo,
        'archived': _archived,
        'authorDisplayName': _authorDisplayName,
        'authorId': _authorId,
        'authorProfilePicURL': _authorProfilePicURL,
        'dev': _dev,
        'isReply': _isReply,
        'likedBy': _likedBy,
        'media': _media?.map((e) => e.toMap()).toList(),
        'messageboardLink': _messageboardLink,
        'replies': _replies,
        'text': _text,
        'title': _title,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'source': serializeParam(
          _source,
          ParamType.String,
        ),
        'ownerId': serializeParam(
          _ownerId,
          ParamType.String,
        ),
        'replyTo': serializeParam(
          _replyTo,
          ParamType.String,
        ),
        'archived': serializeParam(
          _archived,
          ParamType.bool,
        ),
        'authorDisplayName': serializeParam(
          _authorDisplayName,
          ParamType.String,
        ),
        'authorId': serializeParam(
          _authorId,
          ParamType.String,
        ),
        'authorProfilePicURL': serializeParam(
          _authorProfilePicURL,
          ParamType.String,
        ),
        'dev': serializeParam(
          _dev,
          ParamType.bool,
        ),
        'isReply': serializeParam(
          _isReply,
          ParamType.bool,
        ),
        'likedBy': serializeParam(
          _likedBy,
          ParamType.String,
          isList: true,
        ),
        'media': serializeParam(
          _media,
          ParamType.DataStruct,
          isList: true,
        ),
        'messageboardLink': serializeParam(
          _messageboardLink,
          ParamType.String,
        ),
        'replies': serializeParam(
          _replies,
          ParamType.String,
          isList: true,
        ),
        'text': serializeParam(
          _text,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'updatedAt': serializeParam(
          _updatedAt,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static PostStruct fromSerializableMap(Map<String, dynamic> data) =>
      PostStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        source: deserializeParam(
          data['source'],
          ParamType.String,
          false,
        ),
        ownerId: deserializeParam(
          data['ownerId'],
          ParamType.String,
          false,
        ),
        replyTo: deserializeParam(
          data['replyTo'],
          ParamType.String,
          false,
        ),
        archived: deserializeParam(
          data['archived'],
          ParamType.bool,
          false,
        ),
        authorDisplayName: deserializeParam(
          data['authorDisplayName'],
          ParamType.String,
          false,
        ),
        authorId: deserializeParam(
          data['authorId'],
          ParamType.String,
          false,
        ),
        authorProfilePicURL: deserializeParam(
          data['authorProfilePicURL'],
          ParamType.String,
          false,
        ),
        dev: deserializeParam(
          data['dev'],
          ParamType.bool,
          false,
        ),
        isReply: deserializeParam(
          data['isReply'],
          ParamType.bool,
          false,
        ),
        likedBy: deserializeParam<String>(
          data['likedBy'],
          ParamType.String,
          true,
        ),
        media: deserializeStructParam<MediaItemStruct>(
          data['media'],
          ParamType.DataStruct,
          true,
          structBuilder: MediaItemStruct.fromSerializableMap,
        ),
        messageboardLink: deserializeParam(
          data['messageboardLink'],
          ParamType.String,
          false,
        ),
        replies: deserializeParam<String>(
          data['replies'],
          ParamType.String,
          true,
        ),
        text: deserializeParam(
          data['text'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.DateTime,
          false,
        ),
        updatedAt: deserializeParam(
          data['updatedAt'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'PostStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PostStruct &&
        id == other.id &&
        source == other.source &&
        ownerId == other.ownerId &&
        replyTo == other.replyTo &&
        archived == other.archived &&
        authorDisplayName == other.authorDisplayName &&
        authorId == other.authorId &&
        authorProfilePicURL == other.authorProfilePicURL &&
        dev == other.dev &&
        isReply == other.isReply &&
        listEquality.equals(likedBy, other.likedBy) &&
        listEquality.equals(media, other.media) &&
        messageboardLink == other.messageboardLink &&
        listEquality.equals(replies, other.replies) &&
        text == other.text &&
        title == other.title &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        source,
        ownerId,
        replyTo,
        archived,
        authorDisplayName,
        authorId,
        authorProfilePicURL,
        dev,
        isReply,
        likedBy,
        media,
        messageboardLink,
        replies,
        text,
        title,
        createdAt,
        updatedAt
      ]);
}

PostStruct createPostStruct({
  String? id,
  String? source,
  String? ownerId,
  String? replyTo,
  bool? archived,
  String? authorDisplayName,
  String? authorId,
  String? authorProfilePicURL,
  bool? dev,
  bool? isReply,
  String? messageboardLink,
  String? text,
  String? title,
  DateTime? createdAt,
  DateTime? updatedAt,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PostStruct(
      id: id,
      source: source,
      ownerId: ownerId,
      replyTo: replyTo,
      archived: archived,
      authorDisplayName: authorDisplayName,
      authorId: authorId,
      authorProfilePicURL: authorProfilePicURL,
      dev: dev,
      isReply: isReply,
      messageboardLink: messageboardLink,
      text: text,
      title: title,
      createdAt: createdAt,
      updatedAt: updatedAt,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PostStruct? updatePostStruct(
  PostStruct? post, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    post
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPostStructData(
  Map<String, dynamic> firestoreData,
  PostStruct? post,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (post == null) {
    return;
  }
  if (post.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && post.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final postData = getPostFirestoreData(post, forFieldValue);
  final nestedData = postData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = post.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPostFirestoreData(
  PostStruct? post, [
  bool forFieldValue = false,
]) {
  if (post == null) {
    return {};
  }
  final firestoreData = mapToFirestore(post.toMap());

  // Add any Firestore field values
  post.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPostListFirestoreData(
  List<PostStruct>? posts,
) =>
    posts?.map((e) => getPostFirestoreData(e, true)).toList() ?? [];
