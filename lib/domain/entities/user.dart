abstract class User {
  final String id;
  final String username;
  final String email;
  final String phone;
  final int inviteLimit;
  final String? invitedBy;
  final String? sessionToken;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.inviteLimit,
    this.invitedBy,
    this.sessionToken,
  });
}
