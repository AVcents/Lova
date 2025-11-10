import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 📬 Handler pour messages en background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📬 Background message: ${message.messageId}');
}

class FirebaseService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  // 🚀 INITIALISER FIREBASE + NOTIFICATIONS
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();

      // Handler background
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Demander permissions
      await _requestPermission();

      // Setup local notifications
      await _setupLocalNotifications();

      // Écouter les messages
      _setupMessageListeners();

      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization error: $e');
    }
  }

  // 🔔 DEMANDER PERMISSION
  static Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('🔔 Permission status: ${settings.authorizationStatus}');
  }

  // 📱 SETUP LOCAL NOTIFICATIONS
  static Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Canal Android
    const androidChannel = AndroidNotificationChannel(
      'lova_channel',
      'Lova Notifications',
      description: 'Notifications de check-ins et rappels',
      importance: Importance.high,
    );

    // ⬅️ CORRECTION ICI : Ajouter le < manquant
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  // 👂 ÉCOUTER LES MESSAGES
  static void _setupMessageListeners() {
    // App au premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📬 Foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // App ouverte depuis notif
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 Notification tapped: ${message.data}');
      _handleNotificationTap(message.data);
    });

    // App lancée depuis notif (killed state)
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        print('🚀 App opened from notification');
        _handleNotificationTap(message.data);
      }
    });
  }

  // 💾 SAUVEGARDER FCM TOKEN (privée)
  static Future<void> _saveFCMToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        print('📲 FCM Token: $token');

        final supabase = Supabase.instance.client;
        final userId = supabase.auth.currentUser?.id;

        if (userId != null) {
          await supabase.from('users').update({
            'fcm_token': token,
            'updated_at': DateTime.now().toIso8601String(),
          }).eq('id', userId);

          print('✅ FCM token saved to Supabase');
        }
      }

      // Écouter refresh du token
      _messaging.onTokenRefresh.listen((newToken) {
        print('🔄 FCM Token refreshed');
        _saveFCMToken();
      });
    } catch (e) {
      print('❌ Error saving FCM token: $e');
    }
  }

  // ⬅️ MÉTHODE PUBLIQUE AJOUTÉE
  // 💾 Sauvegarder le token pour l'utilisateur actuel
  static Future<void> saveFCMTokenForCurrentUser() async {
    await _saveFCMToken();
  }

  // 📱 AFFICHER NOTIF LOCALE
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'lova_channel',
          'Lova Notifications',
          channelDescription: 'Notifications de check-ins et rappels',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: message.data.toString(),
    );
  }

  // 🎯 GÉRER TAP SUR NOTIF
  static void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      print('🎯 Notification payload: ${response.payload}');
      // TODO: Navigation avec deep links (Tâche 6)
    }
  }

  static void _handleNotificationTap(Map<String, dynamic> data) {
    final type = data['type'];
    print('🎯 Handling notification type: $type');

    // TODO: Navigation avec deep links (Tâche 6)
    // Exemple : si type == 'partner_checkin' -> NavigationService.goToHistory()
  }
}