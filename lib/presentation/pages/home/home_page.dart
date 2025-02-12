import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invite_friends/domain/entities/invite_status.dart';
import 'package:invite_friends/presentation/widgets/custom_elevated_button.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/invite/invites_bloc.dart';
import '../../blocs/invite/invites_event.dart';
import '../../blocs/invite/invites_state.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final invitesBloc = context.read<InvitesBloc>();
    final currentUser = context.read<AuthBloc>().state;

    if (currentUser is AuthAuthenticated) {
      invitesBloc.add(LoadInvites(invitedById: currentUser.userId));
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            currentUser is AuthAuthenticated ? 'Bem-vindo, ${currentUser.username}' : 'Home',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: Colors.black87),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Convites aceitos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<InvitesBloc, InvitesState>(
                  builder: (context, state) {
                    if (state is InvitesLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is InvitesLoaded) {
                      final acceptedInvites = state.invites
                          .where((invite) => invite.status.value == 'accept')
                          .toList();

                      if (acceptedInvites.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhum convite aceito ainda.',
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: acceptedInvites.length,
                        separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
                        itemBuilder: (context, index) {
                          final invite = acceptedInvites[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueGrey[100],
                              child: Icon(Icons.phone, color: Colors.blueGrey[700]),
                            ),
                            title: Text(
                              invite.phone,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              'Status: ${invite.status.value}',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          );
                        },
                      );
                    } else if (state is InvitesError) {
                      return Center(
                        child: Text(
                          'Erro ao carregar convites.',
                          style: TextStyle(fontSize: 16, color: Colors.redAccent),
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        'Nenhum convite encontrado.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/invite'),
                    text: 'Convidar amigos',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
