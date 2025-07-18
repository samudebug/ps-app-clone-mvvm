class Profile {
  final String id;
  final String fullName;
  final String aboutMe;
  final String username;
  final String avatarUrl;

  Profile({
    required this.id,
    required this.fullName,
    required this.aboutMe,
    required this.username,
    required this.avatarUrl,
  });

  @override
  String toString() {
    return 'Profile(id: $id, fullName: $fullName, aboutMe: $aboutMe, username: $username, avatarUrl: $avatarUrl)';
  }
}