import 'package:invite_friends/data/models/invite_model.dart';


abstract class InvitesRepository {
  Future<List<InviteModel>> fetchInvites(String invitedById);
  Future<void> createInvite(String phone, String invitedById, int currentLimit);
  Future<void> updateInviteStatus(String inviteId, String status);
  Future<void> deleteInvite(String inviteId, String userId, int currentLimit);
  Future<void> decrementInviteLimit(String userId);
  Future<void> incrementInviteLimit(String userId);
}
