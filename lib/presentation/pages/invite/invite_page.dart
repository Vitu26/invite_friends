import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:invite_friends/domain/entities/invite_status.dart';
import 'package:invite_friends/presentation/widgets/custom_elevated_button.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/invite/invites_bloc.dart';
import '../../blocs/invite/invites_event.dart';
import '../../blocs/invite/invites_state.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_textfiedl.dart';

class InvitePage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final invitesBloc = context.read<InvitesBloc>();
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;

    if (authState is AuthAuthenticated) {
      invitesBloc.add(LoadInvites(invitedById: authState.userId));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Gerenciar Convites',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<InvitesBloc, InvitesState>(
            listener: (context, state) {
              final authBloc = context.read<AuthBloc>();
              final authState = authBloc.state;

              if (authState is AuthAuthenticated) {
                if (state is InviteCreated || state is InvitesLoaded) {
                  if (state is InviteCreated) {
                    invitesBloc.add(LoadInvites(invitedById: authState.userId));
                    authBloc.add(UserUpdated(userId: authState.userId));
                  }
                } else if (state is InvitesError) {
                  if (state.message.contains("já foi convidado")) {
                    CustomDialog.show(
                      context,
                      title: "Convite já enviado",
                      message: "Este número já foi convidado.",
                      primaryButtonText: 'OK',
                      primaryButtonAction: () {},
                    );
                  } else {
                    invitesBloc.add(LoadInvites(invitedById: authState.userId));
                    CustomDialog.show(
                      context,
                      title: "Erro ao criar convite",
                      message: state.message,
                      primaryButtonText: 'OK',
                      primaryButtonAction: () {},
                    );
                  }
                }
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                print('Número de convites atualizado: ${state.inviteLimit}');
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return Text(
                      'Convites restantes: ${state.inviteLimit}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: phoneController,
                hint: 'Telefone (00) 0 0000-0000',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomElevatedButton(
                  onPressed: () {
                    final authState = context.read<AuthBloc>().state;

                    if (authState is AuthAuthenticated) {
                      final phone = phoneController.text.trim();
                      if (phone.isEmpty) {
                        CustomDialog.show(
                          context,
                          title: 'Telefone inválido',
                          message:
                              'Por favor, insira um número de telefone válido.',
                          primaryButtonText: 'OK',
                          primaryButtonAction: () {},
                        );
                        return;
                      }

                      invitesBloc.add(CreateInvite(
                        phone: phone,
                        invitedById: authState.userId,
                        currentLimit: authState.inviteLimit,
                      ));

                      phoneController.clear();
                    }
                  },
                  text: 'Enviar convite',
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<InvitesBloc, InvitesState>(
                  builder: (context, state) {
                    if (state is InvitesLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (state is InvitesLoaded) {
                      final pendingInvites = state.invites
                          .where((invite) => invite.status.value == 'pending')
                          .toList();

                      if (pendingInvites.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhum convite pendente.',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: pendingInvites.length,
                        separatorBuilder: (_, __) =>
                            Divider(color: Colors.grey[300]),
                        itemBuilder: (context, index) {
                          final invite = pendingInvites[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueGrey[100],
                              child: Icon(Icons.phone,
                                  color: Colors.blueGrey[700]),
                            ),
                            title: Text(
                              invite.phone,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              'Status: Pendente',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                CustomDialog.show(
                                  context,
                                  title: "Remover Convite",
                                  message:
                                      "Tem certeza que deseja remover este convite?",
                                  primaryButtonText: "Sim",
                                  primaryButtonAction: () {
                                    if (authState is AuthAuthenticated) {
                                      invitesBloc.add(DeleteInvite(
                                        inviteId: invite.id,
                                        userId: authState.userId,
                                        currentLimit: authState.inviteLimit,
                                      ));
                                    }
                                  },
                                  secondaryButtonText: "Não",
                                  secondaryButtonAction:
                                      () {}, // Apenas fecha o diálogo
                                );
                              },
                            ),
                          );
                        },
                      );
                    }

                    if (state is InvitesError) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Erro ao carregar convites.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, color: Colors.redAccent),
                          ),
                        ),
                      );
                    }

                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
