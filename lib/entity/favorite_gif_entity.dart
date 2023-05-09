class FavoriteGifEntity {
  static const fieldId = 'id';
  static const fieldTitle = 'title';
  static const fieldPreviewUrl = 'preview_url';
  static const fieldUrl = 'url';
  static const fieldTimestamp = 'timestamp';
  static const fieldDisplayName = 'display_name';
  static const fieldUsername = 'username';
  static const fieldUserProfileUrl = 'user_profile_url';

  final String id;
  final String title;
  final String previewUrl;
  final String url;
  final int timestamp;
  final String? displayName;
  final String? username;
  final String? userProfileUrl;

  FavoriteGifEntity({
    required this.id,
    required this.title,
    required this.previewUrl,
    required this.url,
    required this.timestamp,
    this.displayName,
    this.username,
    this.userProfileUrl,
  });

  FavoriteGifEntity.fromMap(Map<String, dynamic> map)
      : id = map[fieldId] as String,
        title = map[fieldTitle] as String,
        previewUrl = map[fieldPreviewUrl] as String,
        url = map[fieldUrl] as String,
        timestamp = map[fieldTimestamp] as int,
        displayName = map[fieldDisplayName] as String?,
        username = map[fieldUsername] as String?,
        userProfileUrl = map[fieldUserProfileUrl] as String?;

  Map<String, dynamic> toMap() => {
        fieldId: id,
        fieldTitle: title,
        fieldPreviewUrl: previewUrl,
        fieldUrl: url,
        fieldTimestamp: timestamp,
        fieldDisplayName: displayName,
        fieldUsername: username,
        fieldUserProfileUrl: userProfileUrl,
      };
}