import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthEvent {}


class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}


class RegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String phone;
  final String password;

  RegisterRequested({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, phone, password];
}

class LogoutRequested extends AuthEvent {}


class UserUpdated extends AuthEvent {
  final String userId;

  UserUpdated({required this.userId});

  @override
  List<Object> get props => [userId];
}
