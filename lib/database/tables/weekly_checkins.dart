import 'package:drift/drift.dart';

class WeeklyCheckins extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get mood => integer()(); // humeur choisie (1 à 5)
  DateTimeColumn get timestamp =>
      dateTime().withDefault(currentDateAndTime)(); // date du check-in
  TextColumn get userId =>
      text().nullable()(); // plus tard si tu veux distinguer A et B
}
