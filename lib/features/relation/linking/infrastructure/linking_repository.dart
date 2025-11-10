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
    print('🔍 DEBUG: Appel RPC create_or_rotate_invite...');

    try {
      final res = await _sb.rpc('create_or_rotate_invite_v2');

      // LOGGING DETAILLE
      print('🔍 Type de réponse: ${res.runtimeType}');
      print('🔍 Réponse complète: $res');

      if (res is List && res.isNotEmpty) {
        print('🔍 C\'est une liste avec ${res.length} éléments');
        final row = res.first as Map<String, dynamic>;
        print('🔍 Premier élément (row): $row');
        print('🔍 Clés disponibles: ${row.keys.toList()}');
        print('🔍 out_relation_id type: ${row['out_relation_id']?.runtimeType}');
        print('🔍 out_relation_id valeur: ${row['out_relation_id']}');
        print('🔍 out_code type: ${row['out_code']?.runtimeType}');
        print('🔍 out_code valeur: ${row['out_code']}');
        print('🔍 out_expires_at type: ${row['out_expires_at']?.runtimeType}');
        print('🔍 out_expires_at valeur: ${row['out_expires_at']}');

        return (
        relationId: row['out_relation_id'].toString(), // Conversion en String
        code: row['out_code'] as String,
        expiresAt: DateTime.parse(row['out_expires_at'] as String),
        );
      }

      // Si c'est un Map directement
      if (res is Map<String, dynamic>) {
        print('🔍 C\'est un Map directement');
        print('🔍 Clés disponibles: ${res.keys.toList()}');
        print('🔍 out_relation_id type: ${res['out_relation_id']?.runtimeType}');
        print('🔍 out_relation_id valeur: ${res['out_relation_id']}');

        return (
        relationId: res['out_relation_id'].toString(), // Conversion en String
        code: res['out_code'] as String,
        expiresAt: DateTime.parse(res['out_expires_at'] as String),
        );
      }

      // Si on arrive ici, format inattendu
      print('❌ Format de réponse inattendu!');
      throw StateError('Unexpected RPC response for create_or_rotate_invite: ${res.runtimeType}\nContent: $res');

    } catch (e, stackTrace) {
      print('❌ ERREUR dans createOrRotate:');
      print('❌ Type d\'erreur: ${e.runtimeType}');
      print('❌ Message: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Accepte un code et retourne l'id de relation activée
  Future<String> accept(String code, String relationMode) async {
    print('🔍 DEBUG: Acceptation du code: $code avec relation_mode: $relationMode');

    try {
      final relId = await _sb.rpc('accept_invite_v2', params: {
        'p_code': code,
        'p_relation_mode': relationMode,
      });
      print('🔍 Relation ID reçue: $relId (type: ${relId.runtimeType})');
      return relId.toString();
    } catch (e, stackTrace) {
      print('❌ ERREUR dans accept: $e');
      rethrow;
    }
  }

  /// Révoque une relation active
  Future<void> revoke(String relationId) async {
    print('🔍 DEBUG: Révocation de la relation: $relationId');

    try {
      await _sb.rpc('revoke_relation', params: {'p_relation_id': relationId});
      print('✅ Relation révoquée avec succès');
    } catch (e) {
      print('❌ ERREUR dans revoke: $e');
      rethrow;
    }
  }

  /// Flux en temps réel de la relation active (utile pour toggle dashboard)
  Stream<List<Map<String, dynamic>>> activeRelationStream() {
    return _sb
        .from('user_active_relations')
        .stream(primaryKey: ['id']);
  }
}