// lib/features/profile/data/profile_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:lova/features/profile/data/models/profile_checkin_model.dart';
import 'package:lova/features/profile/data/models/profile_streak_model.dart';
import 'package:lova/features/profile/data/models/profile_metrics_model.dart';

class ProfileRepository {
  final SupabaseClient _supabase;
  final _uuid = const Uuid();

  ProfileRepository(this._supabase);

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  // ============================================
  // HELPER: Début de journée
  // ============================================

  /// Retourne le début de la journée actuelle (minuit)
  DateTime _getStartOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // ============================================
  // CHECK-INS (Humeur)
  // ============================================

  /// Créer un check-in du jour
  /// Retourne null si déjà fait aujourd'hui (contrainte DB)
  Future<ProfileCheckin?> createCheckin({
    required int mood,
    String? trigger,
    String? note,
  }) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      // Récupérer la timezone de l'utilisateur
      final userProfile = await _supabase
          .from('users')
          .select('timezone')
          .eq('id', _currentUserId!)
          .single();

      final timezone = userProfile['timezone'] as String? ?? 'UTC';
      final clientUuid = _uuid.v4();

      final response = await _supabase.from('me_checkins').insert({
        'user_id': _currentUserId,
        'client_uuid': clientUuid,
        'ts': DateTime.now().toIso8601String(),
        'timezone_snapshot': timezone,
        'mood': mood,
        'trigger': trigger,
        'note': note,
      }).select().single();

      return ProfileCheckin.fromJson(response);
    } catch (e) {
      // Si contrainte d'unicité violée, retourner null (déjà fait aujourd'hui)
      if (e.toString().contains('duplicate') ||
          e.toString().contains('unique')) {
        return null;
      }
      rethrow;
    }
  }

  /// Récupérer le check-in d'aujourd'hui
  Future<ProfileCheckin?> getTodayCheckin() async {
    if (_currentUserId == null) return null;

    try {
      // ✅ CORRIGÉ: Utiliser le début de la journée au lieu des dernières 24h
      final startOfDay = _getStartOfToday();

      final response = await _supabase
          .from('me_checkins')
          .select()
          .eq('user_id', _currentUserId!)
          .gte('ts', startOfDay.toIso8601String())
          .order('ts', ascending: false)
          .limit(1);

      if (response.isEmpty) return null;

      return ProfileCheckin.fromJson(response.first);
    } catch (e) {
      print('Error fetching today checkin: $e');
      return null;
    }
  }

  /// Récupérer l'historique des check-ins
  Future<List<ProfileCheckin>> getCheckinsHistory({int days = 30}) async {
    if (_currentUserId == null) return [];

    try {
      final startDate = DateTime.now().subtract(Duration(days: days));
      final response = await _supabase
          .from('me_checkins')
          .select()
          .eq('user_id', _currentUserId!)
          .gte('ts', startDate.toIso8601String())
          .order('ts', ascending: false);

      return (response as List)
          .map((json) => ProfileCheckin.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching checkins history: $e');
      return [];
    }
  }

  /// Récupérer l'historique des check-ins pour un utilisateur donné
  Future<List<ProfileCheckin>> getCheckinsHistoryForUser({
    required String userId,
    int days = 30,
  }) async {
    try {
      final startDate = DateTime.now().subtract(Duration(days: days));
      final response = await _supabase
          .from('me_checkins')
          .select()
          .eq('user_id', userId)
          .gte('ts', startDate.toIso8601String())
          .order('ts', ascending: false);

      return (response as List)
          .map((json) => ProfileCheckin.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching checkins history for user $userId: $e');
      return [];
    }
  }

  // ============================================
  // STREAK
  // ============================================

  /// Récupérer le streak actuel
  Future<ProfileStreak?> getStreak() async {
    if (_currentUserId == null) return null;

    try {
      final response = await _supabase
          .from('me_streak')
          .select()
          .eq('user_id', _currentUserId!)
          .maybeSingle();

      if (response == null) {
        // Initialiser le streak si inexistant
        await _supabase.from('me_streak').insert({
          'user_id': _currentUserId,
          'current_streak': 0,
          'best_streak': 0,
        });

        return ProfileStreak(
          userId: _currentUserId!,
          currentStreak: 0,
          bestStreak: 0,
          updatedAt: DateTime.now(),
        );
      }

      return ProfileStreak.fromJson(response);
    } catch (e) {
      print('Error fetching streak: $e');
      return null;
    }
  }

  /// Stream du streak (mise à jour temps réel)
  Stream<ProfileStreak?> watchStreak() {
    if (_currentUserId == null) {
      return Stream.value(null);
    }

    return _supabase
        .from('me_streak')
        .stream(primaryKey: ['user_id'])
        .order('user_id')
        .map((data) {
      if (data.isEmpty) return null;
      // Filtrer côté client car .eq() ne fonctionne pas sur les streams
      final userStreak = data.where((row) => row['user_id'] == _currentUserId).toList();
      if (userStreak.isEmpty) return null;
      return ProfileStreak.fromJson(userStreak.first);
    });
  }

  // ============================================
  // METRICS (Score 7 jours)
  // ============================================

  /// Récupérer les métriques de la semaine courante
  Future<ProfileMetrics?> getCurrentWeekMetrics() async {
    if (_currentUserId == null) return null;

    try {
      // Calculer le lundi de cette semaine
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);

      final response = await _supabase
          .from('me_metrics')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('week_start', weekStartDate.toIso8601String().split('T')[0])
          .maybeSingle();

      if (response == null) {
        // Pas encore de métriques pour cette semaine
        return ProfileMetrics(
          id: '',
          userId: _currentUserId!,
          weekStart: weekStartDate,
          progressScore: 0,
          breakdown: {
            'checkins': 0,
            'rituals_min': 0,
            'journals': 0,
            'streak_active': false,
          },
          updatedAt: DateTime.now(),
        );
      }

      return ProfileMetrics.fromJson(response);
    } catch (e) {
      print('Error fetching metrics: $e');
      return null;
    }
  }

  /// Stream des métriques (mise à jour temps réel)
  Stream<ProfileMetrics?> watchCurrentWeekMetrics() {
    if (_currentUserId == null) {
      return Stream.value(null);
    }

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day)
        .toIso8601String()
        .split('T')[0];

    return _supabase
        .from('me_metrics')
        .stream(primaryKey: ['id'])
        .order('user_id')
        .map((data) {
      if (data.isEmpty) {
        return ProfileMetrics(
          id: '',
          userId: _currentUserId!,
          weekStart: DateTime.parse(weekStartDate),
          progressScore: 0,
          breakdown: {
            'checkins': 0,
            'rituals_min': 0,
            'journals': 0,
            'streak_active': false,
          },
          updatedAt: DateTime.now(),
        );
      }

      // Filtrer côté client
      final userMetrics = data.where((row) =>
      row['user_id'] == _currentUserId &&
          row['week_start'] == weekStartDate
      ).toList();

      if (userMetrics.isEmpty) {
        return ProfileMetrics(
          id: '',
          userId: _currentUserId!,
          weekStart: DateTime.parse(weekStartDate),
          progressScore: 0,
          breakdown: {
            'checkins': 0,
            'rituals_min': 0,
            'journals': 0,
            'streak_active': false,
          },
          updatedAt: DateTime.now(),
        );
      }

      return ProfileMetrics.fromJson(userMetrics.first);
    });
  }

  // ============================================
  // ACTIONS/RITUELS
  // ============================================

  /// Créer une action (respiration, méditation, etc.)
  Future<void> createAction({
    required String type, // 'respiration', 'meditation', 'gratitude', 'custom'
    required String title,
    required int durationMin,
    String? notes,
  }) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      final userProfile = await _supabase
          .from('users')
          .select('timezone')
          .eq('id', _currentUserId!)
          .single();

      final timezone = userProfile['timezone'] as String? ?? 'UTC';
      final clientUuid = _uuid.v4();

      await _supabase.from('me_actions').insert({
        'user_id': _currentUserId,
        'client_uuid': clientUuid,
        'ts': DateTime.now().toIso8601String(),
        'timezone_snapshot': timezone,
        'type': type,
        'title': title,
        'duration_min': durationMin,
        'completed': true,
        'notes': notes,
      });
    } catch (e) {
      // Si limite de 30min atteinte, propager l'erreur
      if (e.toString().contains('30 minutes')) {
        throw Exception('Limite de 30 minutes de rituels par jour atteinte');
      }
      rethrow;
    }
  }

  /// Récupérer les actions du jour
  Future<List<Map<String, dynamic>>> getTodayActions() async {
    if (_currentUserId == null) return [];

    try {
      // ✅ CORRIGÉ: Utiliser le début de la journée au lieu des dernières 24h
      final startOfDay = _getStartOfToday();

      final response = await _supabase
          .from('me_actions')
          .select()
          .eq('user_id', _currentUserId!)
          .gte('ts', startOfDay.toIso8601String())
          .order('ts', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching today actions: $e');
      return [];
    }
  }

  /// Calculer les minutes de rituels utilisées aujourd'hui
  Future<int> getTodayRitualsMinutes() async {
    final actions = await getTodayActions();
    return actions.fold<int>(
      0,
          (sum, action) => sum + (action['duration_min'] as int? ?? 0),
    );
  }

  // ============================================
  // JOURNAL
  // ============================================

  /// Créer une entrée de journal
  Future<void> createJournalEntry({
    required String text,
    List<String>? tags,
  }) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      final userProfile = await _supabase
          .from('users')
          .select('timezone')
          .eq('id', _currentUserId!)
          .single();

      final timezone = userProfile['timezone'] as String? ?? 'UTC';
      final clientUuid = _uuid.v4();

      await _supabase.from('me_journal').insert({
        'user_id': _currentUserId,
        'client_uuid': clientUuid,
        'ts': DateTime.now().toIso8601String(),
        'timezone_snapshot': timezone,
        'text': text,
        'tags': tags,
      });
    } catch (e) {
      if (e.toString().contains('duplicate') ||
          e.toString().contains('unique')) {
        throw Exception('Journal déjà rempli aujourd\'hui');
      }
      rethrow;
    }
  }

  /// Récupérer l'entrée de journal d'aujourd'hui
  Future<Map<String, dynamic>?> getTodayJournal() async {
    if (_currentUserId == null) return null;

    try {
      // ✅ CORRIGÉ: Utiliser le début de la journée au lieu des dernières 24h
      final startOfDay = _getStartOfToday();

      final response = await _supabase
          .from('me_journal')
          .select()
          .eq('user_id', _currentUserId!)
          .gte('ts', startOfDay.toIso8601String())
          .limit(1)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error fetching today journal: $e');
      return null;
    }
  }

  /// Récupérer l'historique des journaux sur N jours
  Future<List<Map<String, dynamic>>> getJournalsHistory({int days = 30}) async {
    if (_currentUserId == null) return [];

    try {
      final startDate = DateTime.now().subtract(Duration(days: days));
      print('Fetching journals history for user $_currentUserId starting from $startDate');
      final response = await _supabase
          .from('me_journal')
          .select()
          .eq('user_id', _currentUserId!)
          .gte('ts', startDate.toIso8601String())
          .order('ts', ascending: false);

      final list = List<Map<String, dynamic>>.from((response is List) ? response : const []);

      // Normalisation: garantir des clés attendues par l'UI
      final normalized = list.map((row) {
        final m = Map<String, dynamic>.from(row);

        // Normaliser la date sur la clé 'date'
        final rawDate = m['date'] ?? m['ts'] ?? m['created_at'];
        m['date'] = rawDate is String
            ? rawDate
            : (rawDate != null ? DateTime.parse(rawDate.toString()).toIso8601String() : DateTime.now().toIso8601String());

        // Valeurs par défaut sûres
        m['text'] = (m['text'] ?? '').toString();
        if (m['word_count'] == null) {
          final txt = m['text'] as String;
          final wc = txt.trim().isEmpty ? 0 : txt.trim().split(RegExp(r'\s+')).length;
          m['word_count'] = wc;
        }
        return m;
      }).toList();

      return normalized;
    } catch (e) {
      print('Error fetching journals history: $e');
      return [];
    }
  }

  /// Récupérer l'historique des actions/rituels sur N jours
  Future<List<Map<String, dynamic>>> getActionsHistory({int days = 30}) async {
    if (_currentUserId == null) return [];

    try {
      final startDate = DateTime.now().subtract(Duration(days: days));
      print('Fetching actions history for user $_currentUserId starting from $startDate');
      final response = await _supabase
          .from('me_actions')
          .select()
          .eq('user_id', _currentUserId!)
          .gte('ts', startDate.toIso8601String())
          .order('ts', ascending: false);

      final list = List<Map<String, dynamic>>.from((response is List) ? response : const []);

      // Normalisation: garantir des clés attendues par l'UI
      final normalized = list.map((row) {
        final m = Map<String, dynamic>.from(row);

        // Normaliser la date sur la clé 'date'
        final rawDate = m['date'] ?? m['ts'] ?? m['created_at'];
        m['date'] = rawDate is String
            ? rawDate
            : (rawDate != null ? DateTime.parse(rawDate.toString()).toIso8601String() : DateTime.now().toIso8601String());

        // Valeurs par défaut sûres
        m['type'] = (m['type'] ?? 'unknown').toString();
        m['title'] = (m['title'] ?? '').toString();
        m['duration_min'] = m['duration_min'] is int
            ? m['duration_min']
            : int.tryParse('${m['duration_min'] ?? 0}') ?? 0;
        return m;
      }).toList();

      return normalized;
    } catch (e) {
      print('Error fetching actions history: $e');
      return [];
    }
  }
  /// Récupérer le résumé d'un mois spécifique
  Future<Map<String, dynamic>?> getMonthSummary({
    required int year,
    required int month,
  }) async {
    if (_currentUserId == null) return null;

    try {
      // Table correcte: me_monthly_analyses
      final response = await _supabase
          .from('me_monthly_analyses')
          .select('year, month, short_summary, ai_insight, stats, correlations, created_at, updated_at')
          .eq('user_id', _currentUserId!)
          .eq('year', year)
          .eq('month', month)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error fetching month summary: $e');
      return null;
    }
  }

  /// Récupérer toutes les analyses mensuelles
  Future<List<Map<String, dynamic>>> getMonthlyAnalyses() async {
    if (_currentUserId == null) return [];

    try {
      // Table correcte: me_monthly_analyses
      final response = await _supabase
          .from('me_monthly_analyses')
          .select('year, month, short_summary, ai_insight, stats, correlations, created_at, updated_at')
          .eq('user_id', _currentUserId!)
          .order('year', ascending: false)
          .order('month', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching monthly analyses: $e');
      return [];
    }
  }

}