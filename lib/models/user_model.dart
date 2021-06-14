class UserModel {
  String? uid;
  String? name;
  String? email;
  String? profilePicture;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.profilePicture,
  });
  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'],
        name: json['name'],
        profilePicture: json['profilePicture'],
        uid: json['uid'],
      );
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'profilePicture': profilePicture,
      };
}
