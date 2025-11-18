import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/features/relation/linking/infrastructure/linking_repository.dart';

/// Provider qui stream la relation active de l'utilisateur connecté
///
/// Retourne un Map avec la structure de user_active_relations :
/// - id: uuid (relation_id)
/// - self_id: uuid (utilisateur courant)
/// - other_id: uuid (partenaire)
/// - status: text
/// - created_at: timestamp
/// - updated_at: timestamp
final activeRelationProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final repo = LinkingRepository(Supabase.instance.client);

  return repo.activeRelationStream().map((list) {
    if (list.isEmpty) return null;
    return list.first;
  });
});

/// Provider pour récupérer le partenaire (User) à partir de other_id
///
/// Retourne un Map avec les infos du partenaire depuis la table users :
/// - id: uuid
/// - prenom: text (surnom/pseudo)
/// - first_name: text
/// - email: text
final partnerInfoProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, partnerId) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase
        .from('users')
        .select('id, prenom, first_name, email')
        .eq('id', partnerId)
        .maybeSingle();

    return response;
  } catch (e) {
    print('Erreur lors de la récupération du partenaire: $e');
    return null;
  }
});
