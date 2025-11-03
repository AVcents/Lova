import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/sos_service.dart';
import '../models/sos_session.dart';

final sosServiceProvider = Provider<SosService>((ref) {
  return SosService(Supabase.instance.client);
});

// Session SOS active du couple
final activeSosSessionProvider = StreamProvider.family<SosSession?, String>((ref, relationId) {
  final sb = Supabase.instance.client;

  return sb
      .from('sos_sessions')
      .stream(primaryKey: ['id'])
      .map((data) {
        // Filtrer les sessions actives de cette relation
        final activeSessions = data
            .where((json) =>
              json['relation_id'] == relationId &&
              json['status'] == 'active'
            )
            .toList();

        if (activeSessions.isEmpty) return null;

        // Trier par started_at DESC et prendre la première
        activeSessions.sort((a, b) =>
          DateTime.parse(b['started_at'] as String)
            .compareTo(DateTime.parse(a['started_at'] as String))
        );

        return SosSession.fromJson(activeSessions.first);
      });
});

// Events d'une session (stream avec filtre client)
final sosEventsProvider = StreamProvider.family.autoDispose<List<SosEvent>, String>((ref, sessionId) {
  final sb = Supabase.instance.client;

  return sb
      .from('sos_events')
      .stream(primaryKey: ['id'])
      .map((allData) {
        // Filtrer les events de cette session côté client
        final sessionEvents = allData
            .where((json) => json['session_id'] == sessionId)
            .toList();

        // Trier par created_at
        sessionEvents.sort((a, b) {
          final aTime = DateTime.parse(a['created_at'] as String);
          final bTime = DateTime.parse(b['created_at'] as String);
          return aTime.compareTo(bTime);
        });

        print('📊 Stream update: ${sessionEvents.length} events for session $sessionId');

        return sessionEvents.map((json) => SosEvent.fromJson(json)).toList();
      });
});

// Historique des sessions SOS (30 dernières)
final sosHistoryProvider = FutureProvider.family<List<SosSession>, String>((ref, relationId) async {
  final sb = Supabase.instance.client;

  final response = await sb
      .from('sos_sessions')
      .select()
      .eq('relation_id', relationId)
      .order('started_at', ascending: false)
      .limit(30);

  return (response as List).map((json) => SosSession.fromJson(json)).toList();
});

// Stats SOS pour card
final sosStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, relationId) async {
  final sessions = await ref.watch(sosHistoryProvider(relationId).future);

  final total = sessions.length;
  final resolved = sessions.where((s) => s.status == SosStatus.resolved).length;
  final avgRating = sessions
      .where((s) => s.resolutionRating != null)
      .fold<double>(0, (sum, s) => sum + s.resolutionRating!) /
      (sessions.where((s) => s.resolutionRating != null).length + 0.1);

  return {
    'total': total,
    'resolved': resolved,
    'avgRating': avgRating,
  };
});
