import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sos_session.dart';

class SosService {
  final SupabaseClient _supabase;

  SosService(this._supabase);

  // Créer session SOS
  Future<SosSession> createSession({
    required String relationId,
    required String initiatedBy,
    required String initialEmotion,
    required String initialDescription,
    required int intensityLevel,
    String? conflictTopic,
  }) async {
    final response = await _supabase
        .from('sos_sessions')
        .insert({
          'relation_id': relationId,
          'initiated_by': initiatedBy,
          'initial_emotion': initialEmotion,
          'initial_description': initialDescription,
          'intensity_level': intensityLevel,
          'conflict_topic': conflictTopic,
          'status': 'active',
        })
        .select()
        .single();

    // Insert event session_started
    await _supabase.from('sos_events').insert({
      'session_id': response['id'],
      'event_type': 'session_started',
      'user_id': initiatedBy,
    });

    return SosSession.fromJson(response);
  }

  // Get session active
  Future<SosSession?> getActiveSession(String relationId) async {
    final response = await _supabase
        .from('sos_sessions')
        .select()
        .eq('relation_id', relationId)
        .eq('status', 'active')
        .order('started_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return response != null ? SosSession.fromJson(response) : null;
  }

  // Stream events session
  Stream<List<SosEvent>> streamEvents(String sessionId) {
    return _supabase
        .from('sos_events')
        .stream(primaryKey: ['id'])
        .map((data) {
          // Filtrer les events de cette session
          final sessionEvents = data
              .where((json) => json['session_id'] == sessionId)
              .toList();

          // Trier par created_at
          sessionEvents.sort((a, b) =>
            DateTime.parse(a['created_at'] as String)
              .compareTo(DateTime.parse(b['created_at'] as String))
          );

          return sessionEvents.map((json) => SosEvent.fromJson(json)).toList();
        });
  }

  // Envoyer message + get réponse AI
  Future<String> sendMessage({
    required String sessionId,
    required String userId,
    required String message,
    required String relationId,
  }) async {
    final response = await _supabase.functions.invoke(
      'generate-sos-response',
      body: {
        'session_id': sessionId,
        'user_message': message,
        'user_id': userId,
        'relation_id': relationId,
      },
    );

    if (response.status != 200) {
      throw Exception('Erreur IA: ${response.data['error']}');
    }

    return response.data['ai_message'] as String;
  }

  // Clôturer session
  Future<void> endSession({
    required String sessionId,
    required int rating,
    String? summary,
  }) async {
    await _supabase.from('sos_sessions').update({
      'status': 'resolved',
      'ended_at': DateTime.now().toIso8601String(),
      'resolution_rating': rating,
      'resolution_summary': summary,
    }).eq('id', sessionId);

    await _supabase.from('sos_events').insert({
      'session_id': sessionId,
      'event_type': 'session_ended',
    });
  }
}
