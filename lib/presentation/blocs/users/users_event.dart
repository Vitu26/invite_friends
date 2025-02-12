import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  final String userId;

  LoadUser({required this.userId});

  @override
  List<Object?> get props => [userId];
}
