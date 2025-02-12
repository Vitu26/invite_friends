import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invite_friends/data/models/user_model.dart';
import 'package:invite_friends/services/parse_service.dart';
import 'package:invite_friends/services/session_service.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final ParseService parseService;

  AuthBloc({required this.authRepository, required this.parseService})
      : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UserUpdated>(_onUserUpdated);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthChecking()); // Adiciona um estado intermediário

    try {
      var currentUser = await SessionService.getUser();


      if (currentUser != null && currentUser.sessionToken != null) {
        final freshUser =
            await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);

        if (freshUser != null &&
            freshUser.success &&
            freshUser.result != null) {
          final user = freshUser.result as ParseUser;

          // Converte ParseUser para User antes de salvar
          final User = UserModel(
            id: user.objectId!,
            username: user.username ?? '',
            email: user.emailAddress ?? '',
            phone: user.get<String>('phone') ?? '',
            inviteLimit: user.get<int>('inviteLimit') ?? 0,
            sessionToken: user.sessionToken,
          );

          await SessionService.saveUser(
              User); // Salva corretamente o modelo de usuário

          emit(AuthAuthenticated(
            userId: User.id,
            username: User.username,
            email: User.email,
            phone: User.phone,
            inviteLimit: User.inviteLimit,
          ));

          return;
        }
      }

      emit(AuthInitial()); // Apenas se nenhum usuário for encontrado
    } catch (e) {
      emit(AuthError(message: 'Erro ao verificar autenticação: $e'));
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(event.username, event.password);


      if (user.sessionToken == null) {
        throw Exception("ERRO: Usuário autenticado sem sessionToken.");
      }

      // Salva o usuário e o token no SessionService
      await SessionService.saveUser(user);

      emit(AuthAuthenticated(
        userId: user.id,
        username: user.username,
        email: user.email,
        phone: user.phone,
        inviteLimit: user.inviteLimit,
      ));


    } catch (e) {

      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {

      final parseUser = await authRepository.register(
        event.username,
        event.email,
        event.phone,
        event.password,
      );

      final user =
          UserModel.fromParseUser(parseUser); // Converte para User

      // Salva a sessão localmente para persistência
      await SessionService.saveUser(user);

      // Atualiza o estado do AuthBloc
      emit(AuthAuthenticated(
        userId: user.id,
        username: user.username,
        email: user.email,
        phone: user.phone,
        inviteLimit: user.inviteLimit,
      ));


    } catch (e) {

      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      await authRepository.logout();
      await SessionService
          .clearUser(); // Remove os dados do usuário ao fazer logout
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(message: 'Erro ao fazer logout.'));
    }
  }

  Future<void> _onUserUpdated(
      UserUpdated event, Emitter<AuthState> emit) async {
    try {
      final user = await parseService.getUser(event.userId);
      final currentState = state;

      if (currentState is AuthAuthenticated) {
        final currentUser = await ParseUser.currentUser() as ParseUser?;

        if (currentUser != null) {
          currentUser.set('inviteLimit', user.inviteLimit);
          await currentUser.save();

          // Atualiza o usuário no armazenamento local
          await SessionService.saveUser(currentUser as UserModel);
        }

        emit(AuthAuthenticated(
          userId: currentState.userId,
          username: currentState.username,
          email: currentState.email,
          phone: currentState.phone,
          inviteLimit: user.inviteLimit,
        ));


      }
    } catch (e) {
      emit(AuthError(message: 'Erro ao atualizar dados do usuário.'));
    }
  }
}
