

String getURL(
  String lastVisitedURL,
  String? token,
) {
  String urlString =
      "https://positionofneutrality.journeyage.com/positionofneutrality/directory";
  if (lastVisitedURL.isNotEmpty &&
      lastVisitedURL != "/positionofneutrality/login") {
    String baseString = "https://positionofneutrality.journeyage.com";
    urlString = baseString + lastVisitedURL;
  }
  if (token != null && token.isNotEmpty) {
    urlString += "?token=$token";
  }
  return urlString;
}

List<String>? getYoutubeVideoIds(String text) {
  List<String> videoIDs = [];
  String pattern =
      r'(?:(?:https?://)?(?:www\.)?(?:youtube\.com|youtu\.be)/(?:live/)?)([\w-]+)';
  RegExp regex = RegExp(pattern, caseSensitive: false);
  Iterable<RegExpMatch> matches = regex.allMatches(text);

  for (RegExpMatch match in matches) {
    if (match.groupCount >= 1) {
      String? videoID = match.group(1);
      if (videoID != null) {
        videoIDs.add(videoID);
      }
    }
  }

  return videoIDs.isNotEmpty ? videoIDs : null;
}
