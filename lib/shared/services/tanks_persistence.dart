import 'package:shared_preferences/shared_preferences.dart';

/// Service de persistance pour les tanks (Love Tank et Me Tank)
class TanksPersistence {
  // Clés de stockage pour Love Tank
  static const String _loveTankValueKey = 'love_value';
  static const String _loveTankLastActionKey = 'love_last';
  static const String _loveTankStreakKey = 'love_streak';

  // Clés de stockage pour Me Tank
  static const String _meTankValueKey = 'me_value';
  static const String _meTankLastActionKey = 'me_last';
  static const String _meTankStreakKey = 'me_streak';

  final SharedPreferences _prefs;

  TanksPersistence(this._prefs);

  /// Factory pour créer une instance avec les préférences
  static Future<TanksPersistence> create() async {
    final prefs = await SharedPreferences.getInstance();
    return TanksPersistence(prefs);
  }

  // ===== Love Tank Methods =====

  /// Charge l'état du Love Tank
  Future<LoveTankData> loadLoveTank() async {
    final value = _prefs.getInt(_loveTankValueKey) ?? 50; // Défaut à 50%
    final lastActionMillis = _prefs.getInt(_loveTankLastActionKey);
    final streakDays = _prefs.getInt(_loveTankStreakKey) ?? 0;

    return LoveTankData(
      value: value.clamp(0, 100),
      lastActionAt: lastActionMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(lastActionMillis)
          : null,
      streakDays: streakDays,
    );
  }

  /// Sauvegarde l'état du Love Tank
  Future<void> saveLoveTank(LoveTankData data) async {
    await _prefs.setInt(_loveTankValueKey, data.value.clamp(0, 100));
    if (data.lastActionAt != null) {
      await _prefs.setInt(
        _loveTankLastActionKey,
        data.lastActionAt!.millisecondsSinceEpoch,
      );
    }
    await _prefs.setInt(_loveTankStreakKey, data.streakDays);
  }

  // ===== Me Tank Methods =====

  /// Charge l'état du Me Tank
  Future<MeTankData> loadMeTank() async {
    final value = _prefs.getInt(_meTankValueKey) ?? 50; // Défaut à 50%
    final lastActionMillis = _prefs.getInt(_meTankLastActionKey);
    final streakDays = _prefs.getInt(_meTankStreakKey) ?? 0;

    return MeTankData(
      value: value.clamp(0, 100),
      lastActionAt: lastActionMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(lastActionMillis)
          : null,
      streakDays: streakDays,
    );
  }

  /// Sauvegarde l'état du Me Tank
  Future<void> saveMeTank(MeTankData data) async {
    await _prefs.setInt(_meTankValueKey, data.value.clamp(0, 100));
    if (data.lastActionAt != null) {
      await _prefs.setInt(
        _meTankLastActionKey,
        data.lastActionAt!.millisecondsSinceEpoch,
      );
    }
    await _prefs.setInt(_meTankStreakKey, data.streakDays);
  }

  /// Réinitialise toutes les données des tanks
  Future<void> clearAll() async {
    await _prefs.remove(_loveTankValueKey);
    await _prefs.remove(_loveTankLastActionKey);
    await _prefs.remove(_loveTankStreakKey);
    await _prefs.remove(_meTankValueKey);
    await _prefs.remove(_meTankLastActionKey);
    await _prefs.remove(_meTankStreakKey);
  }
}

/// Modèle de données pour le Love Tank
class LoveTankData {
  final int value;
  final DateTime? lastActionAt;
  final int streakDays;

  const LoveTankData({
    required this.value,
    this.lastActionAt,
    required this.streakDays,
  });

  LoveTankData copyWith({
    int? value,
    DateTime? lastActionAt,
    int? streakDays,
  }) {
    return LoveTankData(
      value: value ?? this.value,
      lastActionAt: lastActionAt ?? this.lastActionAt,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}

/// Modèle de données pour le Me Tank
class MeTankData {
  final int value;
  final DateTime? lastActionAt;
  final int streakDays;

  const MeTankData({
    required this.value,
    this.lastActionAt,
    required this.streakDays,
  });

  MeTankData copyWith({
    int? value,
    DateTime? lastActionAt,
    int? streakDays,
  }) {
    return MeTankData(
      value: value ?? this.value,
      lastActionAt: lastActionAt ?? this.lastActionAt,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}