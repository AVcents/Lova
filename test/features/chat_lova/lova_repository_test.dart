import 'package:flutter_test/flutter_test.dart';
import 'package:lova/features/chat_lova/models/lova_message.dart';

void main() {
  group('LovaMessage - Model Tests', () {
    test('should create message with all fields', () {
      // Arrange & Act
      final message = LovaMessage(
        id: 'test-id',
        content: 'Test content',
        isFromUser: true,
        timestamp: DateTime(2025, 1, 1),
      );

      // Assert
      expect(message.id, 'test-id');
      expect(message.content, 'Test content');
      expect(message.isFromUser, true);
      expect(message.timestamp, DateTime(2025, 1, 1));
    });

    test('should generate ID if not provided', () {
      // Act
      final message = LovaMessage(
        content: 'Test',
        isFromUser: true,
      );

      // Assert
      expect(message.id, isNotEmpty);
      expect(message.timestamp, isNotNull);
    });

    test('should convert to and from map', () {
      // Arrange
      final original = LovaMessage(
        id: 'test-id',
        content: 'Test content',
        isFromUser: false,
        timestamp: DateTime(2025, 1, 1, 12, 0),
      );

      // Act
      final map = original.toMap();
      final restored = LovaMessage.fromMap(map);

      // Assert
      expect(restored.id, original.id);
      expect(restored.content, original.content);
      expect(restored.isFromUser, original.isFromUser);
      expect(restored.timestamp, original.timestamp);
    });

    test('should create copy with modified fields', () {
      // Arrange
      final original = LovaMessage(
        id: 'id-1',
        content: 'Original',
        isFromUser: true,
      );

      // Act
      final copied = original.copyWith(
        content: 'Modified',
        isFromUser: false,
      );

      // Assert
      expect(copied.id, original.id); // ID unchanged
      expect(copied.content, 'Modified');
      expect(copied.isFromUser, false);
      expect(copied.timestamp, original.timestamp); // timestamp unchanged
    });
  });
}
