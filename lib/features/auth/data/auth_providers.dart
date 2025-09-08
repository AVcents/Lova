import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lova/features/auth/domain/auth_repository.dart';
import 'package:lova/features/auth/data/supabase_auth_repository.dart';

/// Fournit l'implémentation concrète d'AuthRepository pour toute l'app.
/// Remplacez ici par un mock en tests si nécessaire.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = Supabase.instance.client;
  return SupabaseAuthRepository(client);
});
