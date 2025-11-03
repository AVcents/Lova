import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../shared/models/app_notification.dart';
import '../providers/notifications_provider.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // Configure timeago locale to French
    timeago.setLocaleMessages('fr', timeago.FrMessages());
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsStreamProvider);
    final markAllAsRead = ref.read(markAllAsReadProvider);

    // DEBUG
    final userId = Supabase.instance.client.auth.currentUser?.id;
    print('🔍 DEBUG Notifications Page:');
    print('   User ID: $userId');
    print('   Provider state: ${notificationsAsync.toString()}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              try {
                await markAllAsRead();

                // Invalider le provider pour forcer le refresh
                ref.invalidate(notificationsStreamProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Toutes les notifications marquées comme lues')),
                  );
                }
              } catch (e) {
                print('❌ Error marking all as read: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('❌ Erreur lors de la mise à jour'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.done_all, size: 18),
            label: const Text('Tout marquer comme lu'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          final groupedNotifications = _groupNotificationsByDate(notifications);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(notificationsStreamProvider);
            },
            child: ListView.builder(
              itemCount: groupedNotifications.length,
              itemBuilder: (context, index) {
                final group = groupedNotifications[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        group.label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                      ),
                    ),
                    ...group.notifications.map((notification) => _NotificationCard(notification: notification)),
                  ],
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(notificationsStreamProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous n\'avez pas encore de notifications',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  List<_NotificationGroup> _groupNotificationsByDate(List<AppNotification> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeek = today.subtract(const Duration(days: 7));

    final todayNotifs = <AppNotification>[];
    final yesterdayNotifs = <AppNotification>[];
    final thisWeekNotifs = <AppNotification>[];
    final olderNotifs = <AppNotification>[];

    for (final notification in notifications) {
      final date = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      if (date.isAtSameMomentAs(today)) {
        todayNotifs.add(notification);
      } else if (date.isAtSameMomentAs(yesterday)) {
        yesterdayNotifs.add(notification);
      } else if (date.isAfter(thisWeek)) {
        thisWeekNotifs.add(notification);
      } else {
        olderNotifs.add(notification);
      }
    }

    final groups = <_NotificationGroup>[];
    if (todayNotifs.isNotEmpty) groups.add(_NotificationGroup('Aujourd\'hui', todayNotifs));
    if (yesterdayNotifs.isNotEmpty) groups.add(_NotificationGroup('Hier', yesterdayNotifs));
    if (thisWeekNotifs.isNotEmpty) groups.add(_NotificationGroup('Cette semaine', thisWeekNotifs));
    if (olderNotifs.isNotEmpty) groups.add(_NotificationGroup('Plus ancien', olderNotifs));

    return groups;
  }
}

class _NotificationGroup {
  final String label;
  final List<AppNotification> notifications;

  _NotificationGroup(this.label, this.notifications);
}

class _NotificationCard extends ConsumerWidget {
  final AppNotification notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnread = notification.readAt == null;
    final markAsRead = ref.read(markAsReadProvider);
    final deleteNotification = ref.read(deleteNotificationProvider);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        print('🔍 DEBUG: Swipe détecté sur notif ${notification.id}');

        // Demander confirmation
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Supprimer ?'),
            content: const Text('Voulez-vous supprimer cette notification ?'),
            actions: [
              TextButton(
                onPressed: () {
                  print('🔍 DEBUG: Annuler cliqué');
                  Navigator.pop(context, false);
                },
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  print('🔍 DEBUG: Supprimer cliqué');
                  Navigator.pop(context, true);
                },
                child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        print('🔍 DEBUG: Dialog result = $confirm');

        if (confirm != true) {
          print('🔍 DEBUG: Suppression annulée');
          return false;
        }

        // Supprimer en BDD
        print('🔍 DEBUG: Appel deleteNotification pour ${notification.id}');
        try {
          await deleteNotification(notification.id);
          print('🔍 DEBUG: Suppression réussie');

          // Invalider le provider pour forcer le refresh
          ref.invalidate(notificationsStreamProvider);
          print('🔍 DEBUG: Provider invalidé');

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Notification supprimée')),
            );
          }
          return true;

        } catch (e) {
          print('❌ DEBUG: Erreur suppression = $e');

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('❌ Erreur lors de la suppression'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return false;
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: isUnread ? Colors.grey[100] : Colors.white,
        elevation: isUnread ? 2 : 0,
        child: InkWell(
          onTap: () async {
            // Mark as read
            if (isUnread) {
              try {
                await markAsRead(notification.id);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('❌ Erreur lors de la mise à jour'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                print('❌ Error marking as read: $e');
                return; // Arrête l'exécution
              }
            }

            // Navigate only if mark as read succeeded
            if (notification.actionUrl != null && context.mounted) {
              context.push(notification.actionUrl!);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon based on notification type
                _buildNotificationIcon(notification.notificationType),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                                  ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.pink[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Nouveau',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[700],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        timeago.format(notification.createdAt, locale: 'fr'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String notificationType) {
    IconData icon;
    Color color;

    switch (notificationType) {
      case 'couple_checkin':
      case 'partner_checkin':
      case 'couple':
        icon = Icons.favorite;
        color = Colors.pink;
        break;
      case 'me_checkin':
      case 'me':
        icon = Icons.book;
        color = Colors.purple;
        break;
      case 'system':
        icon = Icons.settings;
        color = Colors.grey;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
