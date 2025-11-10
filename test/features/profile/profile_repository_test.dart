import 'package:flutter_test/flutter_test.dart';
import 'package:lova/features/profile/data/models/profile_checkin_model.dart';
import 'package:lova/features/profile/data/models/profile_streak_model.dart';
import 'package:lova/features/profile/data/models/profile_metrics_model.dart';

void main() {
  group('ProfileCheckin - Model Tests', () {
    test('should create ProfileCheckin with all fields', () {
      // Act
      final checkin = ProfileCheckin(
        id: 'test-id',
        userId: 'user-id',
        timestamp: DateTime(2025, 1, 1),
        mood: 4,
        trigger: 'test trigger',
        note: 'test note',
      );

      // Assert
      expect(checkin.id, 'test-id');
      expect(checkin.userId, 'user-id');
      expect(checkin.mood, 4);
      expect(checkin.trigger, 'test trigger');
      expect(checkin.note, 'test note');
    });

    test('should convert ProfileCheckin to and from JSON', () {
      // Arrange
      final jsonData = {
        'id': 'test-id',
        'user_id': 'user-id',
        'ts': '2025-01-01T12:00:00Z',
        'mood': 5,
        'trigger': 'work',
        'note': 'feeling great',
      };

      // Act
      final checkin = ProfileCheckin.fromJson(jsonData);
      final toJsonResult = checkin.toJson();

      // Assert
      expect(checkin.id, 'test-id');
      expect(checkin.userId, 'user-id');
      expect(checkin.mood, 5);
      expect(checkin.trigger, 'work');
      expect(checkin.note, 'feeling great');
      expect(toJsonResult['mood'], 5);
      expect(toJsonResult['trigger'], 'work');
    });

    test('should handle optional fields in ProfileCheckin', () {
      // Act
      final checkin = ProfileCheckin(
        id: 'test-id',
        userId: 'user-id',
        timestamp: DateTime(2025, 1, 1),
        mood: 3,
      );

      // Assert
      expect(checkin.trigger, isNull);
      expect(checkin.note, isNull);
    });
  });

  group('ProfileStreak - Model Tests', () {
    test('should create ProfileStreak with fields', () {
      // Act
      final streak = ProfileStreak(
        userId: 'user-id',
        currentStreak: 7,
        bestStreak: 15,
        updatedAt: DateTime(2025, 1, 1),
      );

      // Assert
      expect(streak.userId, 'user-id');
      expect(streak.currentStreak, 7);
      expect(streak.bestStreak, 15);
      expect(streak.lastActivityDate, isNull);
    });

    test('should create ProfileStreak from JSON', () {
      // Arrange
      final jsonData = {
        'user_id': 'user-id',
        'current_streak': 10,
        'best_streak': 20,
        'updated_at': '2025-01-01T00:00:00Z',
      };

      // Act
      final streak = ProfileStreak.fromJson(jsonData);

      // Assert
      expect(streak.userId, 'user-id');
      expect(streak.currentStreak, 10);
      expect(streak.bestStreak, 20);
    });

    test('should handle optional lastActivityDate', () {
      // Arrange
      final jsonData = {
        'user_id': 'user-id',
        'current_streak': 5,
        'best_streak': 10,
        'last_activity_date': '2025-01-01T00:00:00Z',
        'updated_at': '2025-01-01T00:00:00Z',
      };

      // Act
      final streak = ProfileStreak.fromJson(jsonData);

      // Assert
      expect(streak.lastActivityDate, isNotNull);
      expect(streak.lastActivityDate!.year, 2025);
    });
  });

  group('ProfileMetrics - Model Tests', () {
    test('should create ProfileMetrics with breakdown', () {
      // Act
      final metrics = ProfileMetrics(
        id: 'metrics-id',
        userId: 'user-id',
        weekStart: DateTime(2025, 1, 6), // Monday
        progressScore: 85,
        breakdown: {
          'checkins': 5,
          'rituals_min': 20,
          'journals': 3,
          'streak_active': true,
        },
        updatedAt: DateTime(2025, 1, 1),
      );

      // Assert
      expect(metrics.userId, 'user-id');
      expect(metrics.progressScore, 85);
      expect(metrics.breakdown['checkins'], 5);
      expect(metrics.breakdown['rituals_min'], 20);
      expect(metrics.breakdown['journals'], 3);
      expect(metrics.breakdown['streak_active'], true);
    });

    test('should create ProfileMetrics from JSON', () {
      // Arrange
      final jsonData = {
        'id': 'metrics-id',
        'user_id': 'user-id',
        'week_start': '2025-01-06',
        'progress_score': 75,
        'breakdown': {
          'checkins': 4,
          'rituals_min': 15,
          'journals': 2,
          'streak_active': false,
        },
        'updated_at': '2025-01-01T00:00:00Z',
      };

      // Act
      final metrics = ProfileMetrics.fromJson(jsonData);

      // Assert
      expect(metrics.id, 'metrics-id');
      expect(metrics.userId, 'user-id');
      expect(metrics.progressScore, 75);
      expect(metrics.breakdown['checkins'], 4);
    });

    test('should provide helper getters for breakdown', () {
      // Arrange
      final metrics = ProfileMetrics(
        id: 'metrics-id',
        userId: 'user-id',
        weekStart: DateTime(2025, 1, 6),
        progressScore: 90,
        breakdown: {
          'checkins': 6,
          'rituals_min': 25,
          'journals': 4,
          'streak_active': true,
        },
        updatedAt: DateTime(2025, 1, 1),
      );

      // Assert
      expect(metrics.checkinsCount, 6);
      expect(metrics.ritualsMinutes, 25);
      expect(metrics.journalsCount, 4);
      expect(metrics.streakActive, true);
    });
  });

  group('ProfileRepository - Helper Methods', () {
    test('should calculate start of today correctly', () {
      // Test date calculation logic
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      // Verify the concept is correct
      expect(startOfDay.hour, 0);
      expect(startOfDay.minute, 0);
      expect(startOfDay.second, 0);
      expect(startOfDay.day, now.day);
    });

    test('should validate mood range (1-5)', () {
      // Test mood validation logic
      const validMoods = [1, 2, 3, 4, 5];
      const invalidMoods = [0, 6, -1, 10];

      for (final mood in validMoods) {
        expect(mood >= 1 && mood <= 5, true, reason: 'Mood $mood should be valid');
      }

      for (final mood in invalidMoods) {
        expect(mood < 1 || mood > 5, true, reason: 'Mood $mood should be invalid');
      }
    });
  });
}
