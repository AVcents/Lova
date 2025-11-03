import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/app_notification.dart';

// Supabase client provider
final _supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Current user ID provider
final _currentUserIdProvider = Provider<String?>((ref) {
  final supabase = ref.watch(_supabaseProvider);
  return supabase.auth.currentUser?.id;
});

// Stream of notifications for current user (ordered by created_at DESC)
final notificationsStreamProvider = StreamProvider<List<AppNotification>>((ref) {
  final supabase = ref.watch(_supabaseProvider);
  final userId = ref.watch(_currentUserIdProvider);

  if (userId == null) {
    return Stream.value([]);
  }

  return supabase
      .from('notifications')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .order('created_at', ascending: false)
      .map((data) => data.map((json) => AppNotification.fromJson(json)).toList());
});

// Count of unread notifications
final unreadCountProvider = Provider<int>((ref) {
  final notificationsAsync = ref.watch(notificationsStreamProvider);

  return notificationsAsync.when(
    data: (notifications) => notifications.where((n) => n.readAt == null).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// Mark a single notification as read
final markAsReadProvider = Provider<Future<void> Function(String)>((ref) {
  final supabase = ref.watch(_supabaseProvider);

  return (String notificationId) async {
    try {
      await supabase
          .from('notifications')
          .update({'read_at': DateTime.now().toIso8601String()})
          .eq('id', notificationId);
    } catch (e) {
      print('❌ Error marking notification as read: $e');
      rethrow;
    }
  };
});

// Mark all notifications as read for current user
final markAllAsReadProvider = Provider<Future<void> Function()>((ref) {
  final supabase = ref.watch(_supabaseProvider);
  final userId = ref.watch(_currentUserIdProvider);

  return () async {
    if (userId == null) return;

    try {
      await supabase
          .from('notifications')
          .update({'read_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .isFilter('read_at', null);
    } catch (e) {
      print('❌ Error marking all notifications as read: $e');
      rethrow;
    }
  };
});

// Delete a notification
final deleteNotificationProvider = Provider<Future<void> Function(String)>((ref) {
  final supabase = ref.watch(_supabaseProvider);

  return (String notificationId) async {
    try {
      final userId = ref.read(_currentUserIdProvider);
      if (userId == null) throw Exception('Not authenticated');

      await supabase
          .from('notifications')
          .delete()
          .eq('id', notificationId)
          .eq('user_id', userId);  // Sécurité : ne supprimer que ses propres notifications
    } catch (e) {
      print('❌ Error deleting notification: $e');
      rethrow;
    }
  };
});
