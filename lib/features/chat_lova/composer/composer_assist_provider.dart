// lib/features/chat_lova/composer/composer_assist_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lova/features/chat_lova/composer/composer_assist_repository.dart';

class ComposerAssistParams {
  final int tone; // 0=Chaleureux, 1=Neutre, 2=Assertif
  final int length; // 0=Court, 1=Moyen, 2=Long
  final int empathy; // 0=Faible, 1=Moyenne, 2=Forte

  const ComposerAssistParams({
    this.tone = 0,
    this.length = 0,
    this.empathy = 1,
  });

  ComposerAssistParams copyWith({int? tone, int? length, int? empathy}) {
    return ComposerAssistParams(
      tone: tone ?? this.tone,
      length: length ?? this.length,
      empathy: empathy ?? this.empathy,
    );
  }

  String get toneLabel {
    switch (tone) {
      case 0:
        return 'Chaleureux';
      case 1:
        return 'Neutre';
      case 2:
        return 'Assertif';
      default:
        return 'Chaleureux';
    }
  }

  String get lengthLabel {
    switch (length) {
      case 0:
        return 'Court';
      case 1:
        return 'Moyen';
      case 2:
        return 'Long';
      default:
        return 'Court';
    }
  }

  String get empathyLabel {
    switch (empathy) {
      case 0:
        return 'Faible';
      case 1:
        return 'Moyenne';
      case 2:
        return 'Forte';
      default:
        return 'Moyenne';
    }
  }

  String get profileChip =>
      '$toneLabel • $lengthLabel • Empathie ${empathyLabel.toLowerCase()}';
}

class ComposerAssistState {
  final bool isOpen;
  final bool isLoading;
  final ComposerAssistParams params;
  final List<String> variations;

  const ComposerAssistState({
    this.isOpen = false,
    this.isLoading = false,
    this.params = const ComposerAssistParams(),
    this.variations = const [],
  });

  ComposerAssistState copyWith({
    bool? isOpen,
    bool? isLoading,
    ComposerAssistParams? params,
    List<String>? variations,
  }) {
    return ComposerAssistState(
      isOpen: isOpen ?? this.isOpen,
      isLoading: isLoading ?? this.isLoading,
      params: params ?? this.params,
      variations: variations ?? this.variations,
    );
  }
}

final composerAssistProvider =
    StateNotifierProvider<ComposerAssistNotifier, ComposerAssistState>((ref) {
      final repository = ref.watch(composerAssistRepositoryProvider);
      return ComposerAssistNotifier(repository);
    });

class ComposerAssistNotifier extends StateNotifier<ComposerAssistState> {
  final ComposerAssistRepository repository;

  ComposerAssistNotifier(this.repository) : super(const ComposerAssistState());

  void open() {
    state = state.copyWith(isOpen: true);
  }

  void close() {
    state = state.copyWith(isOpen: false);
  }

  void updateParams({int? tone, int? length, int? empathy}) {
    final newParams = state.params.copyWith(
      tone: tone,
      length: length,
      empathy: empathy,
    );
    state = state.copyWith(params: newParams);
  }

  Future<void> generateVariations(
    List<String> history,
    String contextText,
  ) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, variations: []);

    try {
      final variations = await repository.generate(
        params: state.params,
        history: history,
        contextText: contextText,
      );
      state = state.copyWith(isLoading: false, variations: variations);
    } catch (e) {
      state = state.copyWith(isLoading: false, variations: []);
    }
  }

  void clearVariations() {
    state = state.copyWith(variations: []);
  }
}
