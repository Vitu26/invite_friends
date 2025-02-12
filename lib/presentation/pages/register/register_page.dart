import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart'; // Necessário para `TextInputFormatter`
import 'package:brasil_fields/brasil_fields.dart'; // Import do brasil_fields
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invite_friends/presentation/widgets/custom_dialog.dart';
import 'package:invite_friends/presentation/widgets/custom_elevated_button.dart';
import 'package:invite_friends/presentation/widgets/custom_textfiedl.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthError) {
          CustomDialog.show(
            context,
            title: 'Erro no Registro! Tente novamente!',
            message: state.message,
            primaryButtonText: 'OK',
            primaryButtonAction: () {},
          );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Icon(FontAwesomeIcons.solidMessage,
                    size: MediaQuery.of(context).size.height * 0.19),
                SizedBox(height: 20),
                CustomTextField(
                  controller: usernameController,
                  hint: 'Username',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 8),
                CustomTextField(
                  controller: emailController,
                  hint: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 8),
                CustomTextField(
                  controller: phoneController,
                  hint: 'Telefone (00) 0 0000-0000',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
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
                      text: 'Registrar',
                      backgroundColor: Colors.black,
                      borderRadius: 20,
                      fontSize: 20,
                      textColor: Colors.white,
                      onPressed: () {
                        final username = usernameController.text.trim();
                        final password = passwordController.text.trim();
                        final email = emailController.text.trim();
                        if (username.isEmpty || password.isEmpty || email.isEmpty) {
                          CustomDialog.show(
                            context,
                            title: 'Campos obrigatórios',
                            message: 'Por favor, preencha todos os campos antes de continuar.',
                            primaryButtonText: 'OK',
                            primaryButtonAction: () {},
                          );
                          return;
                        }
                        String phone = phoneController.text.replaceAll(RegExp(r'\D'), '');
                        context.read<AuthBloc>().add(RegisterRequested(
                          username: usernameController.text,
                          email: emailController.text,
                          phone: phone,
                          password: passwordController.text,
                        ));
                      },
                    );
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Já tem uma conta? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: Text(
                        'Faça login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}