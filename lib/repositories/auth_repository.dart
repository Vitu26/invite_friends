import 'package:invite_friends/data/models/user_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../services/parse_service.dart';

class AuthRepository {
  final ParseService parseService;

  AuthRepository({required this.parseService});

  Future<UserModel> login(String username, String password) async {
    final user = ParseUser(username, password, null);
    final response = await user.login();

    if (!response.success || user.objectId == null) {
      throw Exception(
          response.error?.message ?? 'Erro desconhecido durante o login');
    }

    return UserModel(
      id: user.objectId ?? '',
      username: user.username ?? '',
      email: user.emailAddress ?? '',
      phone: user.get<String>('phone') ?? '',
      inviteLimit: user.get<int>('inviteLimit') ?? 0,
      invitedBy: user.get<ParseObject>('invitedBy')?.objectId,
      sessionToken: user.sessionToken,
    );
  }

  Future<ParseUser> register(
    String username,
    String email,
    String phone,
    String password,
  ) async {
    final user = ParseUser(username, password, email)..set('phone', phone);
    final response = await user.signUp();

    if (!response.success) {
      throw Exception(response.error?.message ?? 'Erro no cadastro.');
    }

    return user; // Retorna ParseUser (conversão será feita no AuthBloc)
  }

  Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      await user.logout();
    }
  }
}
