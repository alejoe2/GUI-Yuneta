part of 'models.dart';

LoginModel logingModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String logingModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? username;
  String? password;
  String clientId;
  String grantType;
  bool remember;

  LoginModel({
    this.username,
    this.password,
    this.clientId = "yunetacontrol",
    this.grantType = "password",
    this.remember = false,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        username: json["username"],
        password: json["password"],
        clientId: json["client_id"],
        grantType: json["grant_type"],
        remember: (json["remember"] == null) ? false : json["remember"],
      );

  Map<String, dynamic> toJson() => {
        if (username != null) "username": username,
        if (password != null) "password": password,
        "remember": remember,
        "client_id": clientId,
        "grant_type": grantType,
      };
}
