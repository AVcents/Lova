// lib/features/chat/analysis/conversation_analyzer.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/chat/database/drift_database.dart';
import 'package:lova/shared/models/message_annotation.dart';
import 'package:lova/shared/providers/annotations_provider.dart';

const bool _kAnalyzerDebug = true; // set to false in production

enum InterventionStatus { calm, tension, silence }

class InterventionState {
  final InterventionStatus status;
  final String? reason;
  final DateTime? lastTriggeredAt;

  const InterventionState({
    required this.status,
    this.reason,
    this.lastTriggeredAt,
  });

  InterventionState copyWith({
    InterventionStatus? status,
    String? reason,
    DateTime? lastTriggeredAt,
  }) {
    return InterventionState(
      status: status ?? this.status,
      reason: reason ?? this.reason,
      lastTriggeredAt: lastTriggeredAt ?? this.lastTriggeredAt,
    );
  }
}

class ConversationAnalyzer extends StateNotifier<InterventionState> {
  ConversationAnalyzer(this._ref)
      : super(const InterventionState(status: InterventionStatus.calm));

  final Ref _ref;

  // Seuils (faciles à ajuster en debug)
  static final Duration _bannerThrottle = _kAnalyzerDebug ? const Duration(seconds: 45) : const Duration(minutes: 10);
  static final Duration _silenceDuration = _kAnalyzerDebug ? const Duration(minutes: 60) : const Duration(hours: 12);
  static final Duration _pingPongMaxInterval = _kAnalyzerDebug ? const Duration(seconds: 90) : const Duration(seconds: 60);
  static final int _minExchangesForTension = _kAnalyzerDebug ? 2 : 3; // nb de va-et-vient courts
  static final int _negativeScoreThreshold = _kAnalyzerDebug ? 1 : 2; // nb total de mots négatifs
  static final int _recentWindowMinutes = _kAnalyzerDebug ? 20 : 30;

  DateTime? _snoozeUntil;
  DateTime? _lastBannerShown;

  void analyzeMessages(List<Message> messages) {
    // Garde-fous
    if (_isSnoozing() || _isThrottled() || messages.isEmpty) {
      state = const InterventionState(status: InterventionStatus.calm);
      return;
    }

    // Fenêtre récente triée par timestamp croissant (ancien -> récent)
    final now = DateTime.now();
    final window = messages
        .where((m) => now.difference(m.timestamp).inMinutes <= _recentWindowMinutes)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Liste complète triée par récent -> ancien pour les recherches rapides
    final all = [...messages]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final tension = _checkTension(window, all);
    if (tension != null) {
      _triggerIntervention(InterventionStatus.tension, tension);
      return;
    }

    final silence = _checkSilence(all);
    if (silence != null) {
      _triggerIntervention(InterventionStatus.silence, silence);
      return;
    }

    state = const InterventionState(status: InterventionStatus.calm);
  }

  /// Retourne une raison si tension détectée, sinon null.
  String? _checkTension(List<Message> window, List<Message> all) {
    if (window.length < 3) return null;

    // Exige échanges bilatéraux (au moins 2 expéditeurs)
    final senders = window.map((m) => m.senderId).toSet();
    if (senders.length < 2) return null;

    // Ping‑pong rapide : alternance d’expéditeur et intervalle < seuil
    int quickAlternations = 0;
    for (int i = 1; i < window.length; i++) {
      final prev = window[i - 1];
      final cur = window[i];
      final interval = cur.timestamp.difference(prev.timestamp);
      final alternates = cur.senderId != prev.senderId;
      if (alternates && interval <= _pingPongMaxInterval) {
        quickAlternations++;
      }
    }

    // Score négatif simple (liste de mots)
    const negativeWords = [
      'toujours', 'jamais', 'fatigué', 'fatiguée', 'laisse', 'arrête',
      'marre', 'énervé', 'énervée', 'problème', 'haine', 'triste', 'plus jamais'
    ];
    int negativeScore = 0;
    for (final msg in window) {
      final lc = msg.content.toLowerCase();
      for (final w in negativeWords) {
        if (lc.contains(w)) negativeScore++;
      }
    }

    // Renforcement via tags récents ⚠️ / 🧱 (dans les 10 derniers)
    final last10 = all.take(10);
    final hasWarningTags = last10.any((m) {
      final async = _ref.read(annotationsByMessageProvider(m.id));
      return async.maybeWhen(
        data: (anns) => anns.any((a) =>
            a.tag == AnnotationTag.trigger || a.tag == AnnotationTag.dealbreaker),
        orElse: () => false,
      );
    });

    final tensionDetected =
        (quickAlternations >= _minExchangesForTension &&
            negativeScore > _negativeScoreThreshold) ||
        hasWarningTags;

    if (!tensionDetected) return null;

    return hasWarningTags
        ? 'Échanges rapides + tags sensibles récents'
        : 'Échanges rapides + propos négatifs';
  }

  /// Retourne une raison si silence détecté, sinon null.
  String? _checkSilence(List<Message> allDesc) {
    if (allDesc.length < 2) return null;

    final now = DateTime.now();

    // Dernier message pour chaque expéditeur
    final Map<String, DateTime> lastBySender = {};
    for (final m in allDesc) {
      lastBySender.putIfAbsent(m.senderId, () => m.timestamp);
      if (lastBySender.length >= 2) break; // on a les deux plus récents expéditeurs
    }

    if (lastBySender.length < 2) return null; // besoin d'échanges bilatéraux dans l'historique

    // Plus ancien des deux derniers messages distincts (dernier "des deux côtés")
    final lastBothSides = lastBySender.values.reduce((a, b) => a.isBefore(b) ? a : b);

    final diff = now.difference(lastBothSides);
    if (diff > _silenceDuration) {
      final hours = diff.inHours;
      return 'Aucun échange bilatéral depuis ${hours}h';
    }
    return null;
  }

  bool _isSnoozing() => _snoozeUntil != null && DateTime.now().isBefore(_snoozeUntil!);

  bool _isThrottled() =>
      _lastBannerShown != null && DateTime.now().difference(_lastBannerShown!) < _bannerThrottle;

  void _triggerIntervention(InterventionStatus status, String reason) {
    _lastBannerShown = DateTime.now();
    state = InterventionState(
      status: status,
      reason: reason,
      lastTriggeredAt: DateTime.now(),
    );
  }

  void setSnooze(Duration duration) {
    _snoozeUntil = DateTime.now().add(duration);
    state = const InterventionState(status: InterventionStatus.calm);
  }

  void dismissBanner() {
    state = const InterventionState(status: InterventionStatus.calm);
  }
}

final conversationAnalyzerProvider =
    StateNotifierProvider<ConversationAnalyzer, InterventionState>((ref) {
  return ConversationAnalyzer(ref);
});