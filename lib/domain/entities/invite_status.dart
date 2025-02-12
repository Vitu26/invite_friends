enum InviteStatus {
  pending,
  accept,
  decline,
}

extension InviteStatusExtension on InviteStatus {
  String get value {
    switch (this) {
      case InviteStatus.pending:
        return 'pending';
      case InviteStatus.accept:
        return 'accept';
      case InviteStatus.decline:
        return 'decline';
    }
  }

  static InviteStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return InviteStatus.pending;
      case 'accept':
        return InviteStatus.accept;
      case 'decline':
        return InviteStatus.decline;
      default:
        throw Exception('Invalid InviteStatus value: $value');
    }
  }
}
