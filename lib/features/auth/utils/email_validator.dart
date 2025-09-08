import 'package:flutter/material.dart';

class EmailValidator {
  // Regex amélioré : supporte sous-domaines et TLD longs
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,63}$',
  );

  // Vérification basique du domaine (autorise sous-domaines)
  static final RegExp _validDomainRegex = RegExp(
    r'^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,63}$',
  );

  // Liste de domaines jetables (extrait abrégé)
  static const List<String> _disposableDomains = [
    'tempmail.com',
    'throwaway.email',
    'guerrillamail.com',
    '10minutemail.com',
    'mailinator.com',
    'trashmail.com',
    'yopmail.com',
  ];

  // Typos courantes de domaines populaires
  static const Map<String, String> _commonTypos = {
    'gmial.com': 'gmail.com',
    'gmai.com': 'gmail.com',
    'gmali.com': 'gmail.com',
    'gmail.co': 'gmail.com',
    'gmail.con': 'gmail.com',
    'gmaill.com': 'gmail.com',
    'hotmial.com': 'hotmail.com',
    'hotmal.com': 'hotmail.com',
    'hotmali.com': 'hotmail.com',
    'yahou.com': 'yahoo.com',
    'yaho.com': 'yahoo.com',
    'outlok.com': 'outlook.com',
    'outloo.com': 'outlook.com',
  };

  static EmailValidationResult validate(String email) {
    email = email.trim().toLowerCase();

    // Vérifier format
    if (!_emailRegex.hasMatch(email)) {
      return EmailValidationResult(
        isValid: false,
        reason: 'format',
        error: 'Format d\'email invalide',
      );
    }

    final parts = email.split('@');
    if (parts.length != 2) {
      return EmailValidationResult(
        isValid: false,
        reason: 'format',
        error: 'Format d\'email invalide',
      );
    }

    var localPart = parts[0];
    final domain = parts[1];

    // Normalisation spéciale Gmail
    if (domain == 'gmail.com') {
      // Supprimer tout après un +
      if (localPart.contains('+')) {
        localPart = localPart.split('+')[0];
      }
      // Supprimer les points
      localPart = localPart.replaceAll('.', '');
    }

    // Vérifier domaine valide
    if (!_validDomainRegex.hasMatch(domain)) {
      return EmailValidationResult(
        isValid: false,
        reason: 'domain',
        error: 'Domaine invalide',
      );
    }

    // Vérifier domaines temporaires (exact ou suffixe)
    for (final d in _disposableDomains) {
      if (domain == d || domain.endsWith('.$d')) {
        return EmailValidationResult(
          isValid: false,
          reason: 'disposable',
          error: 'Les emails temporaires ne sont pas acceptés',
        );
      }
    }

    // Détection des fautes courantes
    String? suggestion;
    if (_commonTypos.containsKey(domain)) {
      suggestion = '$localPart@${_commonTypos[domain]}';
    }

    return EmailValidationResult(
      isValid: true,
      suggestion: suggestion,
      normalizedEmail: '$localPart@$domain',
    );
  }

  static bool isValidFormat(String email) {
    return _emailRegex.hasMatch(email.trim());
  }
}

class EmailValidationResult {
  final bool isValid;
  final String? error;
  final String? suggestion;
  final String? reason; // format, domain, disposable
  final String? normalizedEmail;

  const EmailValidationResult({
    required this.isValid,
    this.error,
    this.suggestion,
    this.reason,
    this.normalizedEmail,
  });
}