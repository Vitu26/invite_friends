import 'package:invite_friends/data/models/user_model.dart';


abstract class AuthRepository {
  Future<UserModel> login(String username, String password);
  Future<UserModel> register(String username, String email, String phone, String password);
  Future<void> logout();
}
