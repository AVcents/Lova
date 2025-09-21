import 'package:supabase_flutter/supabase_flutter.dart';

class LinkingRepository {
  final SupabaseClient _sb;
  LinkingRepository(this._sb);

  String? get _uid => _sb.auth.currentUser?.id;

  /// Retourne la relation ACTIVE de l'utilisateur courant, sinon null
  Future<Map<String, dynamic>?> fetchActiveRelation() async {
    final id = _uid;
    if (id == null) return null;
    final row = await _sb
        .from('user_active_relations')
        .select()
        .maybeSingle();
    return row == null ? null : (row as Map<String, dynamic>);
  }

  /// Génère ou régénère un code d'invitation (TTL 5 min)
  Future<({String relationId, String code, DateTime expiresAt})> createOrRotate() async {
    final res = await _sb.rpc('create_or_rotate_invite');
    if (res is List && res.isNotEmpty) {
      final row = res.first as Map<String, dynamic>;
      return (
        relationId: row['out_relation_id'] as String,
        code: row['out_code'] as String,
        expiresAt: DateTime.parse(row['out_expires_at'] as String),
      );
    }
    // Some Postgres clients can return a single row as a map if the function signature changes.
    if (res is Map<String, dynamic>) {
      return (
        relationId: res['out_relation_id'] as String,
        code: res['out_code'] as String,
        expiresAt: DateTime.parse(res['out_expires_at'] as String),
      );
    }
    throw StateError('Unexpected RPC response for create_or_rotate_invite: ${res.runtimeType}');
  }

  /// Accepte un code et retourne l'id de relation activée
  Future<String> accept(String code) async {
    final relId = await _sb.rpc('accept_invite', params: {'p_code': code});
    return relId as String;
  }

  /// Révoque une relation active
  Future<void> revoke(String relationId) async {
    await _sb.rpc('revoke_relation', params: {'p_relation_id': relationId});
  }

  /// Flux en temps réel de la relation active (utile pour toggle dashboard)
  Stream<List<Map<String, dynamic>>> activeRelationStream() {
    return _sb
        .from('user_active_relations')
        .stream(primaryKey: ['id']);
  }
}
