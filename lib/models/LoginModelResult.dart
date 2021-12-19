

import 'package:fin_xp/models/safe_convert.dart';

class LoginModelResult {
  final String tokenType;
  final String accessToken;
  final int expiresIn;
  final String refreshToken;

  LoginModelResult({
    this.tokenType = "",
    this.accessToken = "",
    this.expiresIn = 0,
    this.refreshToken = "",
  });

  factory LoginModelResult.fromJson(Map<String, dynamic> json) => LoginModelResult(
    tokenType: asString(json, 'token_type'),
    accessToken: asString(json, 'access_token'),
    expiresIn: asInt(json, 'expires_in'),
    refreshToken: asString(json, 'refresh_token'),
  );

  Map<String, dynamic> toJson() => {
    'token_type': this.tokenType,
    'access_token': this.accessToken,
    'expires_in': this.expiresIn,
    'refresh_token': this.refreshToken,
  };
}

