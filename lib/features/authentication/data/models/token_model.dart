import 'package:mobile_pihome/features/authentication/domain/entities/token.dart';

class TokenModel extends TokenResponseEntity {
  const TokenModel({
    required super.accessToken,
    required super.tokenType,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['accessToken'],
      tokenType: json['tokenType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'tokenType': tokenType,
    };
  }

  TokenResponseEntity toEntity() {
    return TokenResponseEntity(
      accessToken: accessToken,
      tokenType: tokenType,
    );
  }
}
