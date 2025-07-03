class UserModel {
  final String? id;
  final String? avatarUrl;
  final String? username;
  final String? email;
  final String? role;
  final String? createdAt;
  final String? updateAt;
  final String? accessToken;
  final String? refreshToken;

  UserModel({
    this.id,
    this.avatarUrl,
    this.username,
    this.email,
    this.role,
    this.createdAt,
    this.updateAt,
    this.accessToken,
    this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["user"]["_id"],
      avatarUrl: json["user"]["avatar"]["url"],
      username: json["user"]["username"],
      email: json["user"]["email"],
      role: json["user"]["role"],
      createdAt: json["user"]["createdAt"],
      updateAt: json["user"]["updatedAt"],
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }
}
