import 'package:equatable/equatable.dart';
import 'package:invite_friends/data/models/invite_model.dart';

abstract class InvitesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InvitesInitial extends InvitesState {}

class InvitesLoading extends InvitesState {}

class InvitesLoaded extends InvitesState {
  final List<InviteModel> invites;

  InvitesLoaded({required this.invites});

  @override
  List<Object?> get props => [invites];
}

class InviteCreated extends InvitesState {}

class InvitesError extends InvitesState {
  final String message;

  InvitesError({required this.message});

  @override
  List<Object?> get props => [message];
}
