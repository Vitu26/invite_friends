#  Documentação do Projeto Invite Friends

##  Introdução
O **Invite Friends** é um aplicativo Flutter projetado para gerenciar convites entre usuários. Ele utiliza **BLoC** para gerenciamento de estado, **Back4App (Parse Server)** como backend e segue a arquitetura **Clean Architecture**. O objetivo do projeto é fornecer uma interface fluida e organizada com design minimalista para que os usuários possam enviar e gerenciar convites de forma eficiente.

---

##  Arquitetura do Projeto
O projeto segue a **Clean Architecture**, dividindo responsabilidades em diferentes camadas:

 **lib/** → Contém todo o código-fonte do aplicativo.
  - **core/** → Configurações globais, injeção de dependência.
  - **data/** → Responsável pelo acesso a dados e implementação dos repositórios.
    - `models/` → Modelos de dados.
    - `repositories/` → Implementações dos repositórios.
  - **domain/** → Contém a lógica de negócio independente de infraestrutura.
    - `entities/` → Modelos que representam entidades do domínio.
    - `repositories/` → Interfaces dos repositórios.
    - `usecases/` → Casos de uso do sistema.
  - **presentation/** → Contém a camada de apresentação (UI e estado).
    - `blocs/` → Gerenciamento de estado com BLoC.
    - `pages/` → Telas do aplicativo.
    - `widgets/` → Componentes reutilizáveis.
  - **services/** → Serviços de API e integração com o Parse Server.
  - **utils/** → Funções utilitárias e gerenciamento de rotas.

###  Como a Arquitetura Funciona?
1. A **UI (presentation/pages)** recebe as interações do usuário e aciona eventos no **BLoC**.
2. O **BLoC (presentation/blocs)** lida com eventos e chama os casos de uso (**usecases/**) para executar a lógica de negócio.
3. Os **use cases** acessam os **repositórios**, que por sua vez fazem chamadas para os **serviços da API (Back4App)**.
4. O resultado da chamada é retornado e o estado do aplicativo é atualizado para refletir as mudanças.

---

##  Como Clonar e Rodar o Projeto

### 1️ Clonar o Repositório
Para obter o código-fonte do projeto, execute o seguinte comando:
```bash
git clone https://github.com/Vitu26/invite_friends.git
cd invite_friends
```

### 2️ Instalar Dependências
Antes de rodar o projeto, é necessário instalar as dependências do Flutter:
```bash
flutter pub get
```

### 3️ Configurar o Backend
Antes de executar o app, configure suas credenciais do **Back4App (Parse Server)** no arquivo `lib/services/parse_service.dart`.

### 4️ Executar o Aplicativo
Para rodar o projeto em um emulador ou dispositivo físico, utilize o comando:
```bash
flutter run
```
Se estiver utilizando um emulador, certifique-se de que ele está aberto antes de executar o comando.

Usuário de testes:
  login: teste@gmail.com
  senha: teste123

---

##  Gerenciamento de Autenticação e Persistência de Login

O login dos usuários é gerenciado pelo **Parse Server (Back4App)** e persistido localmente utilizando **SharedPreferences** para manter o usuário autenticado após o fechamento do aplicativo.

- Quando um usuário faz login, o **sessionToken** é salvo localmente.
- No próximo acesso, a sessão é verificada e o usuário é mantido logado.
- O **AuthBloc** gerencia o estado da autenticação, permitindo que a UI reaja adequadamente.

```dart
Future<void> _onCheckAuthStatus(
    CheckAuthStatus event, Emitter<AuthState> emit) async {
  emit(AuthChecking());
  try {
    var currentUser = await SessionService.getUser();
    if (currentUser != null && currentUser.sessionToken != null) {
      final freshUser = await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);
      if (freshUser?.success == true) {
        emit(AuthAuthenticated(user: UserModel.fromParseUser(freshUser.result)));
        return;
      }
    }
    emit(AuthInitial());
  } catch (e) {
    emit(AuthError(message: 'Erro ao verificar autenticação: $e'));
  }
}
```

---

##  Injeção de Dependência (GetIt)
Para facilitar a gestão de dependências, utilizamos o **GetIt**.

```dart
final sl = GetIt.instance;
void init() {
  // Registra serviços
  sl.registerLazySingleton<ParseService>(() => ParseService());
  // Registra repositórios
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(parseService: sl()));
  sl.registerLazySingleton<InvitesRepository>(() => InvitesRepositoryImpl(parseService: sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(parseService: sl()));
}
```

---

##  Configuração do Backend (Back4App)
O backend do projeto está configurado no **Back4App (Parse Server)**. Certifique-se de configurar corretamente as credenciais no arquivo `parse_service.dart`.

### 📊 Estrutura do Banco de Dados
- **User (_User)** → Contém os usuários cadastrados.
- **Convites (Invites)** → Gerencia os convites enviados e recebidos.
- **Configuração (Config)** → Define configurações gerais.

### 🚀 Cloud Code (main.js)
O projeto utiliza **Cloud Code** para regras de negócio antes de salvar dados no banco.

*** Antes de salvar um Usuário (Verifica Convite)**
```javascript
Parse.Cloud.beforeSave(Parse.User, async (request) => {
    const user = request.object;
    if (!user.get("phone")) {
        throw new Parse.Error(400, "O campo 'phone' é obrigatório.");
    }
    const normalizedPhone = user.get("phone").replace(/\D/g, "");
    user.set("phone", normalizedPhone);
    const inviteQuery = new Parse.Query("Invites");
    inviteQuery.equalTo("phone", normalizedPhone);
    const invite = await inviteQuery.first({ useMasterKey: true });
    if (!invite) {
        throw new Parse.Error(403, "Este número de telefone não recebeu um convite.");
    }
    invite.set("status", "accept");
    await invite.save(null, { useMasterKey: true });
    user.set("invitedBy", invite.get("invitedBy"));
    return user;
});
```

*** Antes de salvar um Convite (Evita Duplicidade)**
```javascript
Parse.Cloud.beforeSave("Invites", async (request) => {
    const invite = request.object;
    if (!invite.get("phone")) {
        throw new Parse.Error(400, "O campo 'phone' é obrigatório.");
    }
    const normalizedPhone = invite.get("phone").replace(/\D/g, "");
    invite.set("phone", normalizedPhone);
});
```

---



