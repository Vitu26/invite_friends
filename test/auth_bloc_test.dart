import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:invite_friends/presentation/blocs/auth/auth_bloc.dart';
import 'package:invite_friends/presentation/blocs/auth/auth_event.dart';
import 'package:invite_friends/presentation/blocs/auth/auth_state.dart';
import 'package:invite_friends/repositories/auth_repository.dart';
import 'package:invite_friends/services/parse_service.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockParseService extends Mock implements ParseService {}

class MockParseUser extends Mock implements ParseUser {}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;
  late MockParseService mockParseService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockParseService = MockParseService();
    authBloc = AuthBloc(
        authRepository: mockAuthRepository, parseService: mockParseService);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('O estado inicial deve ser AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    blocTest<AuthBloc, AuthState>(
      'Deve emitir [AuthInitial] quando não houver usuário logado',
      build: () {
        when(ParseUser.currentUser()).thenAnswer((_) async => null);
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckAuthStatus()),
      expect: () => [AuthInitial()],
    );
  });
}
