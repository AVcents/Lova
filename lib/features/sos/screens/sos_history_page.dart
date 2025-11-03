import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/sos_provider.dart';
import '../models/sos_session.dart';

class SosHistoryPage extends ConsumerWidget {
  const SosHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique SOS Couple'),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: _getRelationId(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final relationId = snapshot.data!;
          final historyAsync = ref.watch(sosHistoryProvider(relationId));
          final statsAsync = ref.watch(sosStatsProvider(relationId));

          return historyAsync.when(
            data: (sessions) {
              if (sessions.isEmpty) {
                return _buildEmptyState(context);
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Stats card
                    statsAsync.when(
                      data: (stats) => _buildStatsCard(context, stats),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 20),

                    // Liste sessions
                    ...sessions.map((session) => _buildSessionCard(context, session)),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erreur: $e')),
          );
        },
      ),
    );
  }

  Future<String> _getRelationId() async {
    final sb = Supabase.instance.client;
    final userId = sb.auth.currentUser!.id;

    final members = await sb
        .from('relation_members')
        .select('relation_id')
        .eq('user_id', userId)
        .limit(1);

    if (members.isEmpty) {
      throw Exception('Aucune relation trouvée');
    }

    return members.first['relation_id'] as String;
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🆘', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'Aucune médiation pour le moment',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Les sessions SOS apparaîtront ici',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B9D).withOpacity(0.15),
            const Color(0xFFFFA06B).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF6B9D).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          _buildStatItem(
            context,
            icon: Icons.crisis_alert,
            value: stats['total'].toString(),
            label: 'Sessions',
          ),
          const SizedBox(width: 20),
          _buildStatItem(
            context,
            icon: Icons.check_circle,
            value: stats['resolved'].toString(),
            label: 'Résolues',
          ),
          const SizedBox(width: 20),
          _buildStatItem(
            context,
            icon: Icons.star,
            value: stats['avgRating'].toStringAsFixed(1),
            label: 'Note moy.',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFF6B9D), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, SosSession session) {
    final isResolved = session.status == SosStatus.resolved;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isResolved
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isResolved ? Icons.check_circle : Icons.pending,
                  color: isResolved ? Colors.green : Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE d MMMM', 'fr_FR').format(session.startedAt),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('HH:mm').format(session.startedAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (session.resolutionRating != null)
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      session.resolutionRating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            session.initialDescription,
            style: TextStyle(color: Colors.grey.shade700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip(
                context,
                'Intensité ${session.intensityLevel}/5',
                Colors.red,
              ),
              if (session.conflictTopic != null)
                _buildChip(
                  context,
                  session.conflictTopic!,
                  Colors.blue,
                ),
              _buildChip(
                context,
                '${session.aiResponses} tours IA',
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
