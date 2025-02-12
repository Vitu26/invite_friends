import 'package:invite_friends/data/models/user_model.dart';
import '../services/parse_service.dart';

class UserRepository {
  final ParseService parseService;

  UserRepository({required this.parseService});


Future<UserModel> fetchUser(String userId) async {
    try {

      return await parseService.getUser(userId);
    } catch (e) {

      throw Exception('Erro ao buscar usuário: $e');
    }
  }
}
