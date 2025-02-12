import 'package:invite_friends/data/models/user_model.dart';
import 'package:invite_friends/services/parse_service.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import '../../domain/repositories/user_repository.dart';


class UserRepositoryImpl implements UserRepository {
  final ParseService parseService;

  UserRepositoryImpl({required this.parseService});

  @override
  Future<UserModel> fetchUser(String userId) async {
    try {
      final user = await parseService.getUser(userId);
      return UserModel.fromParseUser(user as ParseUser);
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }
}
