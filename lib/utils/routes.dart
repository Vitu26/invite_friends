import 'package:flutter/material.dart';
import 'package:invite_friends/presentation/pages/home/home_page.dart';
import 'package:invite_friends/presentation/pages/invite/invite_page.dart';
import 'package:invite_friends/presentation/pages/login/login_page.dart';
import 'package:invite_friends/presentation/pages/register/register_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String home = '/home';
  static const String invite = '/invite';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case invite:
        return MaterialPageRoute(builder: (_) => InvitePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Rota não encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
