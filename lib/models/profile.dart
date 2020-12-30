class Profile {
  final String id;
  final String fullName;
  final String avatar;

  Profile({this.id, this.fullName, this.avatar});

  factory Profile.fromMap(Map data) => Profile(
        id: data["id"],
        fullName: data["fullName"],
        avatar: data["avatar"],
      );

  Map<String, dynamic> toMap() => {
        "fullName": fullName,
        "avatar": avatar,
      };
}
