import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../domain/entities/invite.dart';
import '../../domain/entities/invite_status.dart';

class InviteModel extends Invite {
  InviteModel({
    required String id,
    required String phone,
    required InviteStatus status,
    required String invitedById,
    String? invitedByName,
    required DateTime createdAt,
  }) : super(
          id: id,
          phone: phone,
          status: status,
          invitedById: invitedById,
          invitedByName: invitedByName,
          createdAt: createdAt,
        );

  //Construtor para criar `InviteModel` a partir de JSON**
  factory InviteModel.fromJson(Map<String, dynamic> json) {
    final invitedByData = json['invitedBy'] as Map<String, dynamic>?;

    return InviteModel(
      id: json['objectId'] as String,
      phone: json['phone'] as String,
      status: InviteStatusExtension.fromString(json['status'] as String),
      invitedById: invitedByData?['objectId'] ?? 'Não disponível',
      invitedByName: invitedByData?['username'] ?? 'Não disponível',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Método para converter `InviteModel` para JSON**
  Map<String, dynamic> toJson() {
    return {
      'objectId': id,
      'phone': phone,
      'status': status.value,
      'invitedBy': {
        '__type': 'Pointer',
        'className': '_User',
        'objectId': invitedById,
      },
      'createdAt': createdAt.toIso8601String(),
    };
  }

  //Converte um `ParseObject` para `InviteModel`**
  factory InviteModel.fromParseObject(ParseObject parseObject) {
    return InviteModel(
      id: parseObject.objectId ?? '',
      phone: parseObject.get<String>('phone') ?? '',
      status: InviteStatusExtension.fromString(parseObject.get<String>('status') ?? 'pending'),
      invitedById: (parseObject.get<ParseObject>('invitedBy')?.objectId) ?? 'Não disponível',
      invitedByName: (parseObject.get<ParseObject>('invitedBy')?.get<String>('username')) ?? 'Não disponível',
      createdAt: parseObject.createdAt ?? DateTime.now(),
    );
  }
}
