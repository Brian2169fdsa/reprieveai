// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class MediaItemStruct extends FFFirebaseStruct {
  MediaItemStruct({
    String? filename,
    String? originalURL,
    String? thumbnailURL,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _filename = filename,
        _originalURL = originalURL,
        _thumbnailURL = thumbnailURL,
        super(firestoreUtilData);

  // "filename" field.
  String? _filename;
  String get filename => _filename ?? '';
  set filename(String? val) => _filename = val;

  bool hasFilename() => _filename != null;

  // "originalURL" field.
  String? _originalURL;
  String get originalURL => _originalURL ?? '';
  set originalURL(String? val) => _originalURL = val;

  bool hasOriginalURL() => _originalURL != null;

  // "thumbnailURL" field.
  String? _thumbnailURL;
  String get thumbnailURL => _thumbnailURL ?? '';
  set thumbnailURL(String? val) => _thumbnailURL = val;

  bool hasThumbnailURL() => _thumbnailURL != null;

  static MediaItemStruct fromMap(Map<String, dynamic> data) => MediaItemStruct(
        filename: data['filename'] as String?,
        originalURL: data['originalURL'] as String?,
        thumbnailURL: data['thumbnailURL'] as String?,
      );

  static MediaItemStruct? maybeFromMap(dynamic data) => data is Map
      ? MediaItemStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'filename': _filename,
        'originalURL': _originalURL,
        'thumbnailURL': _thumbnailURL,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'filename': serializeParam(
          _filename,
          ParamType.String,
        ),
        'originalURL': serializeParam(
          _originalURL,
          ParamType.String,
        ),
        'thumbnailURL': serializeParam(
          _thumbnailURL,
          ParamType.String,
        ),
      }.withoutNulls;

  static MediaItemStruct fromSerializableMap(Map<String, dynamic> data) =>
      MediaItemStruct(
        filename: deserializeParam(
          data['filename'],
          ParamType.String,
          false,
        ),
        originalURL: deserializeParam(
          data['originalURL'],
          ParamType.String,
          false,
        ),
        thumbnailURL: deserializeParam(
          data['thumbnailURL'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MediaItemStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MediaItemStruct &&
        filename == other.filename &&
        originalURL == other.originalURL &&
        thumbnailURL == other.thumbnailURL;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([filename, originalURL, thumbnailURL]);
}

MediaItemStruct createMediaItemStruct({
  String? filename,
  String? originalURL,
  String? thumbnailURL,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MediaItemStruct(
      filename: filename,
      originalURL: originalURL,
      thumbnailURL: thumbnailURL,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MediaItemStruct? updateMediaItemStruct(
  MediaItemStruct? mediaItem, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    mediaItem
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMediaItemStructData(
  Map<String, dynamic> firestoreData,
  MediaItemStruct? mediaItem,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (mediaItem == null) {
    return;
  }
  if (mediaItem.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && mediaItem.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final mediaItemData = getMediaItemFirestoreData(mediaItem, forFieldValue);
  final nestedData = mediaItemData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = mediaItem.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMediaItemFirestoreData(
  MediaItemStruct? mediaItem, [
  bool forFieldValue = false,
]) {
  if (mediaItem == null) {
    return {};
  }
  final firestoreData = mapToFirestore(mediaItem.toMap());

  // Add any Firestore field values
  mediaItem.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMediaItemListFirestoreData(
  List<MediaItemStruct>? mediaItems,
) =>
    mediaItems?.map((e) => getMediaItemFirestoreData(e, true)).toList() ?? [];
