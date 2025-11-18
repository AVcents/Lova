// lib/shared/repositories/annotations_repository_supabase.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/shared/models/message_annotation.dart';
import 'package:lova/shared/repositories/annotations_repository.dart';

class AnnotationsRepositorySupabase implements AnnotationsRepository {
  final SupabaseClient _supabase;

  AnnotationsRepositorySupabase(this._supabase);

  @override
  Future<List<MessageAnnotation>> listByCouple(
      String coupleId, {
        String? userId,
        AnnotationTag? filter,
        String? query,
      }) async {
    var q = _supabase
        .from('couple_message_annotations')
        .select()
        .eq('relation_id', coupleId);

    // Filtre par utilisateur (pour voir seulement SES tags)
    if (userId != null) {
      q = q.eq('user_id', userId);
    }

    if (filter != null) {
      q = q.eq('tag', filter.name);
    }

    if (query != null && query.isNotEmpty) {
      q = q.ilike('note', '%$query%');
    }

    final data = await q.order('created_at', ascending: false);
    return (data as List).map((json) => _mapFromSupabase(json)).toList();
  }

  @override
  Future<List<MessageAnnotation>> listByMessage(String messageId) async {
    final data = await _supabase
        .from('couple_message_annotations')
        .select()
        .eq('message_id', messageId)
        .order('created_at', ascending: false);

    return (data as List).map((json) => _mapFromSupabase(json)).toList();
  }

  @override
  Stream<List<MessageAnnotation>> listByMessageStream(String messageId) {
    return _supabase
        .from('couple_message_annotations')
        .stream(primaryKey: ['id'])
        .eq('message_id', messageId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => _mapFromSupabase(json)).toList());
  }

  /// Mapping depuis Supabase (snake_case) vers MessageAnnotation
  MessageAnnotation _mapFromSupabase(Map<String, dynamic> json) {
    return MessageAnnotation(
      id: json['id'] as String,
      messageId: json['message_id'] as String,
      coupleId: json['relation_id'] as String,
      authorUserId: json['user_id'] as String,
      tag: AnnotationTag.fromString(json['tag'] as String),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  Future<void> add(MessageAnnotation annotation) async {
    await _supabase.from('couple_message_annotations').insert({
      'id': annotation.id,
      'message_id': annotation.messageId.toString(),
      'relation_id': annotation.coupleId,
      'user_id': annotation.authorUserId,
      'tag': annotation.tag.name,
      'note': annotation.note,
      'is_shared': annotation.tag == AnnotationTag.loveQuality,
      'created_at': annotation.createdAt.toIso8601String(),
    });
  }

  @override
  Future<void> remove(String annotationId) async {
    await _supabase
        .from('couple_message_annotations')
        .delete()
        .eq('id', annotationId);
  }

  @override
  Future<void> update(MessageAnnotation annotation) async {
    await _supabase.from('couple_message_annotations').update({
      'note': annotation.note,
    }).eq('id', annotation.id);
  }

  @override
  Future<MessageAnnotation?> getById(String annotationId) async {
    final data = await _supabase
        .from('couple_message_annotations')
        .select()
        .eq('id', annotationId)
        .maybeSingle();

    return data != null ? _mapFromSupabase(data) : null;
  }

  @override
  Future<bool> hasUserTag(String messageId, String userId, AnnotationTag tag) async {
    final data = await _supabase
        .from('couple_message_annotations')
        .select('id')
        .eq('message_id', messageId)
        .eq('user_id', userId)
        .eq('tag', tag.name)
        .maybeSingle();

    return data != null;
  }

  @override
  Future<int> countByCouple(String coupleId, {String? userId, AnnotationTag? filter}) async {
    var q = _supabase
        .from('couple_message_annotations')
        .select('id')
        .eq('relation_id', coupleId);

    if (userId != null) {
      q = q.eq('user_id', userId);
    }

    if (filter != null) {
      q = q.eq('tag', filter.name);
    }

    final data = await q;
    return (data as List).length;
  }
}