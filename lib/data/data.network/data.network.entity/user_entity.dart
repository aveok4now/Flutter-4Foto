class UserEntity{
  final String? profileUrl;
  final String? username;
  final String? displayName;

  UserEntity({
    this.profileUrl,
    this.username,
    this.displayName,
  });


  factory UserEntity.fromJson(Map<String, dynamic> json){
    return UserEntity(
      profileUrl: json['profile_url'] as String?,
      username: json['username'] as String?,
      displayName: json ['display_name'] as String?,

    );
  }
}