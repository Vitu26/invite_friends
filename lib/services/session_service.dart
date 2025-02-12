import 'dart:convert';
import 'package:invite_friends/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SessionService {
  static const String _userKey = 'stored_user';

  //Salva o usuário no SharedPreferences**
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userData);

  }

  // Recupera o usuário do SharedPreferences**
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString(_userKey);

    if (storedUser == null) {

      return null;
    }

    final userData = jsonDecode(storedUser);
    if (userData['sessionToken'] == null) {

      return null;
    }

    final user = UserModel.fromJson(userData);
    return user;
  }

  //Limpa os dados do usuário (logout)**
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);

  }
}
