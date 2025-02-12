import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invite_friends/presentation/widgets/custom_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invite_friends/presentation/widgets/custom_elevated_button.dart';
import 'package:invite_friends/presentation/widgets/custom_textfiedl.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navegar para a página inicial ao sucesso do login
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            // Exibir erro em caso de falha no login
            CustomDialog.show(
              context,
              title: 'Erro no Login! Tente novamente!',
              message: state.message,
              primaryButtonText: 'OK',
              primaryButtonAction: () {},
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20,),
              Icon(FontAwesomeIcons.solidMessage, size: MediaQuery.of(context).size.height * 0.19),
              SizedBox(height: 20,),
              CustomTextField(
                controller: userController,
                hint: 'E-mail',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 8),
              CustomTextField(
                controller: passwordController,
                hint: 'Senha',
                isPassword: true,
                showToggleVisibility: true,
              ),
              SizedBox(height: 16),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return CustomElevatedButton(
                    text: 'Login',
                    backgroundColor: Colors.black,
                    borderRadius: 20,
                    fontSize: 20,
                    textColor: Colors.white,
                    onPressed: () {
                      final username = userController.text.trim();
                      final password = passwordController.text.trim();

                      if (username.isEmpty || password.isEmpty) {
                        // Exibir alerta caso os campos estejam vazios
                        CustomDialog.show(
                          context,
                          title: 'Campos obrigatórios',
                          message:
                              'Por favor, preencha todos os campos antes de continuar.',
                          primaryButtonText: 'OK',
                          primaryButtonAction: () {},
                        );
                        return;
                      }
                      // Aciona o evento de login
                      context.read<AuthBloc>().add(
                            LoginRequested(
                              username: userController.text,
                              password: passwordController.text,
                            ),
                          );
                    },
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Não tem uma conta? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Registre-se',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
