part of './models.dart';

TokenResponse tokenResponseFromJson(String str) => TokenResponse.fromJson(json.decode(str));

String tokenResponseToJson(TokenResponse data) => json.encode(data.toJson());

class TokenResponse {
  String clientId;
  int? refreshExpiresIn;
  int? expiresIn;
  String? tokenType;
  String? sessionState;
  String? accessToken;
  String? refreshToken;
  String? scope;

  TokenResponse({
    this.clientId = "yunetacontrol",
    this.refreshExpiresIn,
    this.expiresIn,
    this.tokenType,
    this.sessionState,
    this.accessToken,
    this.refreshToken,
    this.scope,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        clientId: json["client_id"] ?? "yunetacontrol",
        refreshExpiresIn: json["refresh_expires_in"],
        expiresIn: json["expires_in"],
        tokenType: json["token_type"],
        sessionState: json["session_state"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        scope: json["scope"],
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        if (refreshExpiresIn != null) "refresh_expires_in": refreshExpiresIn,
        if (expiresIn != null) "expires_in": expiresIn,
        if (tokenType != null) "token_type": tokenType,
        if (sessionState != null) "session_state": sessionState,
        if (accessToken != null) "access_token": accessToken,
        if (refreshToken != null) "refresh_token": refreshToken,
        if (scope != null) "scope": scope,
      };
}
