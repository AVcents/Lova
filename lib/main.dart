import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  print('🔐 API Key chargée : ${dotenv.env['OPENAI_API_KEY']}');
  runApp(const ProviderScope(child: App()));
}