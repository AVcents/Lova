import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DashboardMode { me, us }

class DashboardModeNotifier extends StateNotifier<DashboardMode> {
  static const String _storageKey = 'dashboard_mode';

  DashboardModeNotifier() : super(DashboardMode.us) {
    _loadSavedMode();
  }

  Future<void> _loadSavedMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_storageKey);

    if (savedMode != null) {
      state = savedMode == 'me' ? DashboardMode.me : DashboardMode.us;
    }
  }

  Future<void> setMode(DashboardMode mode) async {
    state = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, mode == DashboardMode.me ? 'me' : 'us');
  }
}

final dashboardModeProvider = StateNotifierProvider<DashboardModeNotifier, DashboardMode>((ref) {
  return DashboardModeNotifier();
});