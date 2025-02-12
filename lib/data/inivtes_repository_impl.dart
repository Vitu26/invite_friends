import 'dart:developer';
import 'package:invite_friends/data/models/invite_model.dart';
import 'package:invite_friends/repositories/invites_repository.dart';
import 'package:invite_friends/services/parse_service.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';


class InvitesRepositoryImpl implements InvitesRepository {
  final ParseService parseService;

  InvitesRepositoryImpl({required this.parseService});

  @override
  Future<List<InviteModel>> fetchInvites(String invitedById) async {
    log('Buscando convites para o usuário: $invitedById');
    try {
      final invites = await parseService.getInvites(invitedById);
      log('Convites encontrados: ${invites.length}');
      return invites.map((i) => InviteModel.fromParseObject(i as ParseObject)).toList();
    } catch (e) {
      log('Erro ao buscar convites: $e', level: 2);
      throw Exception('Erro ao buscar convites: $e');
    }
  }

  @override
  Future<void> createInvite(String phone, String invitedById, int currentLimit) async {
    try {
      await parseService.createInvite(phone, invitedById, currentLimit);
    } catch (e) {
      throw Exception('Erro ao criar convite: $e');
    }
  }

  @override
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

  @override
  Future<void> deleteInvite(String inviteId, String userId, int currentLimit) async {
    try {
      await parseService.deleteInvite(inviteId, userId, currentLimit);
    } catch (e) {
      throw Exception('Erro ao deletar convite: $e');
    }
  }

  @override
  Future<void> decrementInviteLimit(String userId) async {
    await parseService.decrementInviteLimit(userId);
  }

  @override
  Future<void> incrementInviteLimit(String userId) async {
    await parseService.incrementInviteLimit(userId);
  }
}
