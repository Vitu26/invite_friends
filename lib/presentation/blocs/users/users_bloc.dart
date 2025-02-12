import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invite_friends/presentation/blocs/users/users_event.dart';
import 'package:invite_friends/presentation/blocs/users/users_state.dart';
import 'package:invite_friends/repositories/user_respository.dart';



class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await userRepository.fetchUser(event.userId);
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  
}
