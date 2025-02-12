import 'package:invite_friends/data/models/user_model.dart';
import 'package:invite_friends/services/parse_service.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../domain/repositories/auth_repository.dart';



class AuthRepositoryImpl implements AuthRepository {
  final ParseService parseService;

  AuthRepositoryImpl({required this.parseService});

  @override
  Future<UserModel> login(String username, String password) async {
    final user = ParseUser(username, password, null);
    final response = await user.login();

    if (!response.success || user.objectId == null) {
      throw Exception(
          response.error?.message ?? 'Erro desconhecido durante o login');
    }

    return UserModel.fromParseUser(user);
  }

  @override
  Future<UserModel> register(String username, String email, String phone, String password) async {
    final user = ParseUser(username, password, email)..set('phone', phone);
    final response = await user.signUp();

    if (!response.success) {
      throw Exception(response.error?.message ?? 'Erro no cadastro.');
    }

    return UserModel.fromParseUser(user);
  }

  @override
  Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      await user.logout();
    }
  }
}
