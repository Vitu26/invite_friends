import 'dart:developer';
import 'package:invite_friends/data/models/invite_model.dart';
import 'package:invite_friends/services/parse_service.dart';

class InvitesRepository {
  final ParseService parseService;

  InvitesRepository({required this.parseService});

  Future<List<InviteModel>> fetchInvites(String invitedById) async {
    log('Buscando convites para o usuário: $invitedById');
    try {
      final invites = await parseService.getInvites(invitedById);
      log('Convites encontrados: ${invites.length}');
      return invites;
    } catch (e) {
      log('Erro ao buscar convites: $e', level: 2);
      throw Exception('Erro ao buscar convites: $e');
    }
  }

Future<void> createInvite(String phone, String invitedById, int currentLimit) async {
  try {
    await parseService.createInvite(phone, invitedById, currentLimit);
  } catch (e) {
    throw Exception('Erro ao criar convite: $e');
  }
}


  Future<void> updateInviteStatus(String inviteId, String status) async {
    log('Atualizando status do convite $inviteId para $status');
    try {
      await parseService.updateInviteStatus(inviteId, status);
      log('Status do convite atualizado com sucesso para $status');
    } catch (e) {
      log('Erro ao atualizar status do convite: $e', level: 2);
      throw Exception('Erro ao atualizar convite: $e');
    }
  }

Future<void> deleteInvite(String inviteId, String userId, int currentLimit) async {
  try {
    await parseService.deleteInvite(inviteId, userId, currentLimit);
  } catch (e) {
    throw Exception('Erro ao deletar convite: $e');
  }
}


  Future<void> decrementInviteLimit(String userId) async {
    await parseService.decrementInviteLimit(userId);
  }

  Future<void> incrementInviteLimit(String userId) async {
    await parseService.incrementInviteLimit(userId);
  }
}
