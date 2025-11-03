import 'dart:io';

void main() async {
  final file = File('assets/animations/splash_loova.json');
  final content = await file.readAsString();

  final fixed = content
      .replaceAll('"k":[0,0,0,1]', '"k":[1,1,1,1]')
      .replaceAll('[0,0,0,1]', '[1,1,1,1]');

  await File('assets/animations/splash_loova_fixed.json').writeAsString(fixed);
  print('✅ Fichier corrigé créé !');
}