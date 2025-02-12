import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invite_friends/core/dependency_injection.dart';
import 'package:invite_friends/presentation/blocs/auth/auth_bloc.dart';
import 'package:invite_friends/presentation/blocs/auth/auth_event.dart';
import 'package:invite_friends/presentation/blocs/auth/auth_state.dart';
import 'package:invite_friends/presentation/blocs/invite/invites_bloc.dart';
import 'package:invite_friends/repositories/auth_repository.dart';
import 'package:invite_friends/repositories/invites_repository.dart';
import 'package:invite_friends/services/parse_service.dart';
import 'package:invite_friends/presentation/pages/home/home_page.dart';
import 'package:invite_friends/presentation/pages/invite/invite_page.dart';
import 'package:invite_friends/presentation/pages/login/login_page.dart';
import 'package:invite_friends/presentation/pages/register/register_page.dart';
import 'package:invite_friends/utils/route_transitions.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();

  const keyApplicationId = 'emBU0AEGZWvL1JXY9Hr64puM5uO2eQEGeTbfsQjO';
  const keyClientKey = 'BwFCg0z8Z5pYQKM5iMmODVSCsstNWKDBBOigRcaM';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
  );

  final parseService = ParseService();
  final authRepository = AuthRepository(parseService: parseService);
  final currentUser = await ParseUser.currentUser() as ParseUser?;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
              authRepository: authRepository, parseService: parseService)
            ..add(CheckAuthStatus()),
        ),
        BlocProvider(
          create: (context) => InvitesBloc(
            invitesRepository: InvitesRepository(parseService: parseService),
            authBloc: context.read<AuthBloc>(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Invite Friends',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return HomePage();
                  } else if (state is AuthInitial || state is AuthError) {
                    return LoginPage();
                  }
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                },
              ),
            );
          case '/home':
            return RouteTransitions.slideTransition(HomePage());
          case '/invite':
            return RouteTransitions.slideTransition(InvitePage());
          case '/register':
            return RouteTransitions.slideTransition(RegisterPage());
          default:
            return MaterialPageRoute(
                builder: (context) => Scaffold(
                      body: Center(child: Text('Página não encontrada')),
                    ));
        }
      },
    );
  }
}
