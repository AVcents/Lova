import 'package:lova/features/chat_lova/data/lova_repository.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/chat_lova/data/mock_lova_repository.dart';
import 'package:lova/features/chat_lova/data/real_lova_repository.dart';

final useRealLovaApiProvider = Provider<bool>((ref) => true);

final lovaRepositoryProvider = Provider<LovaRepository>((ref) {
  final useReal = ref.watch(useRealLovaApiProvider);
  return useReal ? RealLovaRepository() : MockLovaRepository();
});