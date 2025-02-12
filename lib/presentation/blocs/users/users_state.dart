import 'package:equatable/equatable.dart';
import 'package:invite_friends/data/models/user_model.dart';


abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;

  UserLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
