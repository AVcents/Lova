import 'package:flutter_test/flutter_test.dart';
import 'package:lova/features/auth/data/supabase_auth_repository.dart';
import 'package:lova/features/auth/domain/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mocks
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockAuthResponse extends Mock implements AuthResponse {}
class MockUser extends Mock implements User {}
class MockAuthException extends Mock implements AuthException {}

void main() {
  late MockSupabaseClient mockClient;
  late MockGoTrueClient mockAuth;
  late SupabaseAuthRepository repository;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(() => mockClient.auth).thenReturn(mockAuth);
    repository = SupabaseAuthRepository(mockClient);
  });

  group('SupabaseAuthRepository - signUp', () {
    test('signUp success returns AuthResult with success true', () async {
      // Arrange
      final mockUser = MockUser();
      final mockResponse = MockAuthResponse();
      when(() => mockResponse.user).thenReturn(mockUser);
      when(() => mockAuth.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        emailRedirectTo: any(named: 'emailRedirectTo'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.signUp(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.success, true);
      expect(result.message, 'Inscription réussie');
      expect(result.data, mockUser);
    });

    test('signUp with email confirmation returns success with message', () async {
      // Arrange
      final mockResponse = MockAuthResponse();
      when(() => mockResponse.user).thenReturn(null);
      when(() => mockAuth.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        emailRedirectTo: any(named: 'emailRedirectTo'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.signUp(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.success, true);
      expect(result.message, 'Confirmation email envoyée');
      expect(result.data, null);
    });

    test('signUp with emailAlreadyInUse error returns mapped error', () async {
      // Arrange
      when(() => mockAuth.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        emailRedirectTo: any(named: 'emailRedirectTo'),
      )).thenThrow(AuthException('User already registered'));

      // Act
      final result = await repository.signUp(
        email: 'existing@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.success, false);
      expect(result.errorType, AuthErrorType.emailAlreadyInUse);
      expect(result.message, 'Cet email est déjà utilisé');
    });
  });

  group('SupabaseAuthRepository - signIn', () {
    test('signIn success returns AuthResult with user', () async {
      // Arrange
      final mockUser = MockUser();
      final mockResponse = MockAuthResponse();
      when(() => mockResponse.user).thenReturn(mockUser);
      when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.success, true);
      expect(result.message, 'Connexion réussie');
      expect(result.data, mockUser);
    });

    test('signIn with wrong password returns mapped error', () async {
      // Arrange
      when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow(AuthException('Invalid login credentials'));

      // Act
      final result = await repository.signIn(
        email: 'test@example.com',
        password: 'wrongpassword',
      );

      // Assert
      expect(result.success, false);
      expect(result.errorType, AuthErrorType.wrongPassword);
      expect(result.message, 'Email ou mot de passe incorrect');
    });

    test('signIn with null user returns failure', () async {
      // Arrange
      final mockResponse = MockAuthResponse();
      when(() => mockResponse.user).thenReturn(null);
      when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.success, false);
      expect(result.message, 'Email ou mot de passe incorrect');
    });
  });

  group('SupabaseAuthRepository - signOut', () {
    test('signOut calls client.auth.signOut', () async {
      // Arrange
      when(() => mockAuth.signOut()).thenAnswer((_) async => {});

      // Act
      await repository.signOut();

      // Assert
      verify(() => mockAuth.signOut()).called(1);
    });
  });

  group('SupabaseAuthRepository - currentUser', () {
    test('currentUser returns current user from auth', () {
      // Arrange
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // Act
      final user = repository.currentUser();

      // Assert
      expect(user, mockUser);
    });

    test('currentUser returns null when not authenticated', () {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // Act
      final user = repository.currentUser();

      // Assert
      expect(user, null);
    });
  });

  group('SupabaseAuthRepository - error mapping', () {
    test('maps rate limit error correctly', () async {
      // Arrange
      when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow(AuthException('too many requests', statusCode: '429'));

      // Act
      final result = await repository.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.errorType, AuthErrorType.tooManyAttempts);
      expect(result.message, 'Trop de tentatives, réessayez plus tard');
    });

    test('maps network error correctly', () async {
      // Arrange
      when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow(AuthException('network timeout'));

      // Act
      final result = await repository.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.errorType, AuthErrorType.networkError);
      expect(result.message, 'Problème réseau. Réessayez.');
    });
  });
}
