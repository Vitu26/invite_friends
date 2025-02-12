import 'package:invite_friends/data/models/user_model.dart';


abstract class UserRepository {
  Future<UserModel> fetchUser(String userId);
}
