
import 'package:invite_friends/domain/entities/user.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String username,
    required String email,
    required String phone,
    required int inviteLimit,
    String? invitedBy,
    String? sessionToken,
  }) : super(
          id: id,
          username: username,
          email: email,
          phone: phone,
          inviteLimit: inviteLimit,
          invitedBy: invitedBy,
          sessionToken: sessionToken,
        );

  /// **✅ Converte um `ParseUser` para `UserModel`**
  factory UserModel.fromParseUser(ParseUser user) {
    return UserModel(
      id: user.objectId ?? '',
      username: user.username ?? '',
      email: user.emailAddress ?? '',
      phone: user.get<String>('phone') ?? '',
      inviteLimit: user.get<int>('inviteLimit') ?? 0,
      invitedBy: user.get<ParseObject>('invitedBy')?.objectId,
      sessionToken: user.sessionToken, // 🔹 Garante que o sessionToken seja salvo
    );
  }

  /// **🔄 Construtor para criar `UserModel` a partir de JSON**
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['objectId'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      inviteLimit: json['inviteLimit'] as int,
      invitedBy: json['invitedBy']?['objectId'], // Caso seja um Pointer no Back4App
      sessionToken: json['sessionToken'],
    );
  }

  /// **📝 Método para converter `UserModel` para JSON**
  Map<String, dynamic> toJson() {
    return {
      'objectId': id,
      'username': username,
      'email': email,
      'phone': phone,
      'inviteLimit': inviteLimit,
      'invitedBy': invitedBy != null
          ? {'__type': 'Pointer', 'className': '_User', 'objectId': invitedBy}
          : null,
      'sessionToken': sessionToken,
    };
  }
}
