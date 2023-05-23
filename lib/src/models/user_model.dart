part of 'models.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? sub;
  bool? emailVerified;
  String? name;
  String? preferredUsername;
  String? givenName;
  String? locale;
  String? familyName;
  String? email;

  UserModel({
    this.sub,
    this.emailVerified,
    this.name,
    this.preferredUsername,
    this.givenName,
    this.locale,
    this.familyName,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        sub: json["sub"],
        emailVerified: json["email_verified"],
        name: json["name"],
        preferredUsername: json["preferred_username"],
        givenName: json["given_name"],
        locale: json["locale"],
        familyName: json["family_name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "sub": sub,
        "email_verified": emailVerified,
        "name": name,
        "preferred_username": preferredUsername,
        "given_name": givenName,
        "locale": locale,
        "family_name": familyName,
        "email": email,
      };
}
