import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invite_friends/presentation/blocs/auth/auth_bloc.dart';
import 'package:invite_friends/presentation/blocs/auth/auth_event.dart';
import 'package:invite_friends/presentation/blocs/invite/invites_event.dart';
import 'package:invite_friends/presentation/blocs/invite/invites_state.dart';
import 'package:invite_friends/repositories/invites_repository.dart';

class InvitesBloc extends Bloc<InvitesEvent, InvitesState> {
  final InvitesRepository invitesRepository;
  final AuthBloc authBloc;

  InvitesBloc({required this.invitesRepository,required this.authBloc}) : super(InvitesInitial()) {
    on<LoadInvites>(_onLoadInvites);
    on<CreateInvite>(_onCreateInvite);
    on<UpdateInviteStatus>(_onUpdateInviteStatus);
    on<DeleteInvite>(_onDeleteInvite);
  }

  Future<void> _onLoadInvites(
      LoadInvites event, Emitter<InvitesState> emit) async {
    emit(InvitesLoading());

    try {
      final invites = await invitesRepository.fetchInvites(event.invitedById);

      emit(InvitesLoaded(invites: invites));
    } catch (e) {

      emit(InvitesError(message: e.toString()));
    }
  }

  Future<void> _onCreateInvite(
      CreateInvite event, Emitter<InvitesState> emit) async {

    try {
      await invitesRepository.createInvite(
          event.phone, event.invitedById, event.currentLimit);

      emit(InviteCreated());
    } catch (e) {

      emit(InvitesError(message: e.toString()));
    }
  }

  Future<void> _onUpdateInviteStatus(
      UpdateInviteStatus event, Emitter<InvitesState> emit) async {

    try {
      await invitesRepository.updateInviteStatus(event.inviteId, event.status);

      emit(InvitesInitial());
    } catch (e) {

      emit(InvitesError(message: e.toString()));
    }
  }

  Future<void> _onDeleteInvite(
      DeleteInvite event, Emitter<InvitesState> emit) async {
    try {


      await invitesRepository.deleteInvite(
          event.inviteId, event.userId, event.currentLimit);

      final updatedInvites = await invitesRepository.fetchInvites(event.userId);

      emit(InvitesLoaded(invites: updatedInvites));


      authBloc.add(UserUpdated(userId: event.userId));
    } catch (e) {

      emit(InvitesError(message: e.toString()));
    }
  }
}
