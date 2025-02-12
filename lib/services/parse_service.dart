import 'package:invite_friends/data/models/invite_model.dart';
import 'package:invite_friends/data/models/user_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';


class ParseService {
  Future<UserModel> login(String username, String password) async {
    final user = ParseUser(username, password, null);
    final response = await user.login();


    if (!response.success || user.objectId == null) {
      throw Exception(
          response.error?.message ?? 'Erro desconhecido durante o login');
    }

    if (user.sessionToken == null) {
      throw Exception("ERRO: Usuário autenticado sem sessionToken.");
    }



    return UserModel(
      id: user.objectId ?? '',
      username: user.username ?? '',
      email: user.emailAddress ?? '',
      phone: user.get<String>('phone') ?? '',
      inviteLimit: user.get<int>('inviteLimit') ?? 0,
      invitedBy: user.get<ParseObject>('invitedBy')?.objectId,
      sessionToken: user.sessionToken, //  GARANTE QUE O TOKEN É RETORNADO
    );
  }

  Future<UserModel> register(
      String username, String email, String phone, String password) async {
    final user = ParseUser(username, password, email)..set('phone', phone);

    final signupResponse = await user.signUp();

    if (!signupResponse.success) {
      throw Exception(signupResponse.error?.message ?? 'Erro no cadastro.');
    }

    return UserModel(
      id: user.objectId ?? '',
      username: user.username ?? '',
      email: user.emailAddress ?? '',
      phone: user.get<String>('phone') ?? '',
      inviteLimit: 5,
    );
  }

  Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      await user.logout();
    }
  }

  Future<UserModel> getUser(String userId) async {


    final query = QueryBuilder<ParseUser>(ParseUser.forQuery())
      ..whereEqualTo('objectId', userId);

    final response = await query.query();

    if (!response.success || response.results == null) {
      throw Exception(response.error?.message ?? 'Usuário não encontrado.');
    }

    final user = response.results!.first as ParseUser;



    //  Apenas retorna os dados, sem sobrescrever a sessão local
    return UserModel(
      id: user.objectId ?? '',
      username: user.username ?? '',
      email: user.emailAddress ?? '',
      phone: user.get<String>('phone') ?? '',
      inviteLimit: user.get<int>('inviteLimit') ?? 0,
    );
  }

  Future<List<InviteModel>> getInvites(String invitedById) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Invites'))
      ..whereEqualTo('invitedBy', ParseObject('_User')..objectId = invitedById)
      ..includeObject(['invitedBy']);

    final response = await query.query();

    if (!response.success) {
      throw Exception(response.error?.message ?? 'Erro ao buscar convites.');
    }

    return response.results?.map((e) {
          return InviteModel.fromJson(e.toJson());
        }).toList() ??
        [];
  }

  Future<void> createInvite(
      String phone, String invitedById, int currentLimit) async {
    if (currentLimit <= 0) {
      throw Exception('Você não pode enviar mais convites.');
    }

    final invite = ParseObject('Invites')
      ..set('phone', phone)
      ..set('invitedBy', ParseObject('_User')..objectId = invitedById)
      ..set('status', 'pending');

    final response = await invite.save();

    if (!response.success) {

      throw Exception('Erro ao criar convite: ${response.error?.message}');
    }



    // Atualizar o limite do usuário
    await updateInviteLimit(invitedById, currentLimit - 1);
  }

  Future<void> updateInviteLimit(String userId, int newLimit) async {
    final query = QueryBuilder<ParseUser>(ParseUser.forQuery())
      ..whereEqualTo('objectId', userId);

    final response = await query.query();

    if (!response.success || response.results == null) {
      throw Exception('Usuário não encontrado ao tentar atualizar limite.');
    }

    final user = response.results!.first as ParseUser;

    // Atualiza apenas o inviteLimit sem modificar os dados do usuário
    user.set('inviteLimit', newLimit);
    final updateResponse = await user.save();

    if (!updateResponse.success) {
      throw Exception(
          'Erro ao atualizar limite de convites: ${updateResponse.error?.message}');
    }

    // Mantém a sessão ativa
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null && currentUser.sessionToken != null) {
      await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);
    }
  }

  Future<void> updateInviteStatus(String inviteId, String status) async {

    final invite = ParseObject('Invites')..objectId = inviteId;
    invite.set('status', status);

    final response = await invite.save();
    if (!response.success) {

      throw Exception(response.error?.message ?? 'Erro ao atualizar status.');
    }
  }

  Future<void> decrementInviteLimit(String userId) async {
    final userQuery = QueryBuilder<ParseUser>(ParseUser.forQuery())
      ..whereEqualTo('objectId', userId);

    final userResponse = await userQuery.query();

    if (userResponse.success && userResponse.results != null) {
      final user = userResponse.results!.first as ParseUser;
      final currentLimit = user.get<int>('inviteLimit') ?? 0;

      user.set('inviteLimit', currentLimit - 1);
      await user.save();
    }
  }

  Future<void> incrementInviteLimit(String userId) async {
    final userQuery = QueryBuilder<ParseUser>(ParseUser.forQuery())
      ..whereEqualTo('objectId', userId);

    final userResponse = await userQuery.query();

    if (userResponse.success && userResponse.results != null) {
      final user = userResponse.results!.first as ParseUser;
      final currentLimit = user.get<int>('inviteLimit') ?? 0;

      user.set('inviteLimit', currentLimit + 1);
      await user.save();
    }
  }

  Future<void> deleteInvite(
      String inviteId, String userId, int currentLimit) async {
    final invite = ParseObject('Invites')..objectId = inviteId;

    final response = await invite.delete();
    if (!response.success) {
      throw Exception('Erro ao deletar convite: ${response.error?.message}');
    }

    // Atualiza apenas o inviteLimit sem resetar o login
    await updateInviteLimit(userId, currentLimit + 1);
  }
}
