import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:lova/database/tables/weekly_checkins.dart';

part 'app_database.g.dart'; // Drift va générer ce fichier automatiquement

@DriftDatabase(tables: [WeeklyCheckins])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Méthode pour insérer un check-in
  Future<void> insertWeeklyCheckin(int mood) async {
    into(weeklyCheckins).insert(WeeklyCheckinsCompanion(mood: Value(mood)));
  }

  // Lire tous les check-ins (utile pour tests ou graphique)
  Future<List<WeeklyCheckin>> getAllCheckins() async {
    return select(weeklyCheckins).get();
  }
}

// Méthode pour ouvrir la base
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lova.sqlite'));
    return NativeDatabase(file);
  });
}
