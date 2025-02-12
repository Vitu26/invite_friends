import 'package:get_it/get_it.dart';
import 'package:invite_friends/data/auth_repository_impl.dart';
import 'package:invite_friends/data/inivtes_repository_impl.dart';
import 'package:invite_friends/data/user_repository_impl.dart';
import 'package:invite_friends/domain/repositories/auth_repository.dart';
import 'package:invite_friends/domain/repositories/user_repository.dart';
import 'package:invite_friends/repositories/invites_repository.dart';
import 'package:invite_friends/services/parse_service.dart';

final sl = GetIt.instance;

void init() {
  // Serviços
  sl.registerLazySingleton<ParseService>(() => ParseService());

  // Repositórios
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(parseService: sl()));
  sl.registerLazySingleton<InvitesRepository>(() => InvitesRepositoryImpl(parseService: sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(parseService: sl()));
}
