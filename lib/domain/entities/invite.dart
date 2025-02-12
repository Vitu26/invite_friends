import 'package:invite_friends/domain/entities/invite_status.dart';

abstract class Invite {
  final String id;
  final String phone;
  final InviteStatus status;
  final String invitedById; // ID do convidado
  final String? invitedByName; // Nome do convidado (opcional)
  final DateTime createdAt;

  Invite({
    required this.id,
    required this.phone,
    required this.status,
    required this.invitedById,
    this.invitedByName,
    required this.createdAt,
  });
}
