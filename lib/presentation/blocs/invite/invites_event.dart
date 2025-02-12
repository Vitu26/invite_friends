import 'package:equatable/equatable.dart';

abstract class InvitesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadInvites extends InvitesEvent {
  final String invitedById;

  LoadInvites({required this.invitedById});

  @override
  List<Object?> get props => [invitedById];
}

class CreateInvite extends InvitesEvent {

  final String phone;

  final String invitedById;

  final int currentLimit;



  CreateInvite({required this.phone, required this.invitedById, required this.currentLimit});

}


class UpdateInviteStatus extends InvitesEvent {
  final String inviteId;
  final String status;

  UpdateInviteStatus({required this.inviteId, required this.status});

  @override
  List<Object?> get props => [inviteId, status];
}

class DeleteInvite extends InvitesEvent {
  final String inviteId;
  final String userId;
  final int currentLimit;

  DeleteInvite({
    required this.inviteId,
    required this.userId,
    required this.currentLimit,
  });
}



