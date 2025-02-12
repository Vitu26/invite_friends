import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String username;
  final String email;
  final String phone;
  final int inviteLimit;

  AuthAuthenticated({
    required this.userId,
    required this.username,
    required this.email,
    required this.phone,
    required this.inviteLimit,
  });

  @override
  List<Object?> get props => [userId, username, email, phone, inviteLimit];
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthChecking extends AuthState {}

