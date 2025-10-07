import 'package:supabase_flutter/supabase_flutter.dart';

final _sb = Supabase.instance.client;

const kBucketAvatars = 'avatars';
const kBucketRelationMedia = 'relation-media';

// UUID v4 simple
final _uuidRe = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  caseSensitive: false,
);

/// Signed URL pour un média de relation privé.
/// `objectPath` est le chemin RELATIF **après** <relationId>/ (ex: 'photos/demo.txt')
Future<String?> signRelationMedia({
  required String relationId,
  required String objectPath,
  int expiresSec = 120,
}) async {
  // garde-fous
  final userResp = await _sb.auth.getUser();
  final user = userResp.user;
  if (user == null) return null; // pas de session
  if (!_uuidRe.hasMatch(relationId)) return null; // relationId invalide

  final cleanPath = objectPath.startsWith('/') ? objectPath.substring(1) : objectPath;
  final fullPath = '$relationId/$cleanPath'; // ex: <rel>/photos/demo.txt

  try {
    final url = await _sb.storage
        .from(kBucketRelationMedia)
        .createSignedUrl(fullPath, expiresSec);
    return url; // String
  } on StorageException {
    return null; // RLS ou objet introuvable
  } catch (_) {
    return null;
  }
}

/// Signed URL pour l’avatar privé de l’utilisateur courant.
Future<String?> signMyAvatar({int expiresSec = 60}) async {
  final userResp = await _sb.auth.getUser();
  final user = userResp.user;
  if (user == null) return null;

  final path = 'users/${user.id}/avatar.png';
  try {
    final url = await _sb.storage
        .from(kBucketAvatars)
        .createSignedUrl(path, expiresSec);
    return url;
  } on StorageException {
    return null;
  } catch (_) {
    return null;
  }
}