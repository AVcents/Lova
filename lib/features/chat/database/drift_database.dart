import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'drift_database.g.dart'; // Nécessaire pour la génération

// 1️⃣ Définir la table
class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get senderId => text()();
  TextColumn get receiverId => text()();
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get isEncrypted => boolean().withDefault(const Constant(false))();
}

// 2️⃣ Définir la base de données
@DriftDatabase(tables: [Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD de base
  Future<List<Message>> getAllMessages() => select(messages).get();
  Future<void> insertMessage(MessagesCompanion message) =>
      into(messages).insert(message);
  Future<void> clearMessages() => delete(messages).go();
}

// 3️⃣ Ouvrir la base
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'chat_couple.sqlite'));
    return NativeDatabase(file);
  });
}