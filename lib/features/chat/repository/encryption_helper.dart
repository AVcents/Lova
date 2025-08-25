import 'dart:convert';
import 'package:cryptography/cryptography.dart';

class EncryptionHelper {
  // Symmetric key (ne pas exposer en prod)
  static final _secretKey = SecretKey(List.generate(32, (i) => i)); // clé fixe

  // Chiffrement simple avec AES-GCM
  static Future<String> encrypt(String plainText) async {
    final algorithm = AesGcm.with256bits();
    final secretBox = await algorithm.encrypt(
      utf8.encode(plainText),
      secretKey: _secretKey,
    );
    return base64Encode(secretBox.concatenation());
  }

  static Future<String> decrypt(String encryptedText) async {
    final algorithm = AesGcm.with256bits();
    final secretBox = SecretBox.fromConcatenation(
      base64Decode(encryptedText),
      nonceLength: algorithm.nonceLength,
      macLength: algorithm.macAlgorithm.macLength,
    );
    final clearBytes = await algorithm.decrypt(
      secretBox,
      secretKey: _secretKey,
    );
    return utf8.decode(clearBytes);
  }
}