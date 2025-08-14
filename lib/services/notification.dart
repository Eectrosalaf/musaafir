// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class NotificationService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _localNotifications = 
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     try {
//       // Request permission
//       await _messaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );

//       // Initialize local notifications
//       const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//       const iosSettings = DarwinInitializationSettings();
//       const initSettings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );
      
//       await _localNotifications.initialize(
//         initSettings,
//         onDidReceiveNotificationResponse: _onNotificationTapped,
//       );

//       // Get FCM token and save to user document
//       String? token = await _messaging.getToken();
//       if (token != null) {
//         await _saveTokenToDatabase(token);
//       }

//       // Listen for token refresh
//       _messaging.onTokenRefresh.listen(_saveTokenToDatabase);

//       // Handle foreground messages
//       FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
//       // Handle background messages
//       FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     } catch (e) {
//       print('Error initializing notifications: $e');
//     }
//   }

//   static void _onNotificationTapped(NotificationResponse response) {
//     // Handle notification tap
//     print('Notification tapped: ${response.payload}');
//   }

//   static Future<void> _saveTokenToDatabase(String token) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .update({'fcmToken': token});
//       }
//     } catch (e) {
//       print('Error saving FCM token: $e');
//     }
//   }

//   static Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     try {
//       const androidDetails = AndroidNotificationDetails(
//         'chat_channel',
//         'Chat Messages',
//         channelDescription: 'Notifications for new chat messages',
//         importance: Importance.high,
//         priority: Priority.high,
//         showWhen: true,
//       );

//       const iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );
      
//       const details = NotificationDetails(
//         android: androidDetails, 
//         iOS: iosDetails,
//       );

//       await _localNotifications.show(
//         message.hashCode,
//         message.notification?.title ?? 'New Message',
//         message.notification?.body ?? 'You have a new message',
//         details,
//         payload: message.data['chatId'],
//       );
//     } catch (e) {
//       print('Error handling foreground message: $e');
//     }
//   }

//   static Future<void> sendNotificationToUser(String userId, String title, String body) async {
//     try {
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
      
//       if (userDoc.exists) {
//         final data = userDoc.data();
//         if (data != null && data.containsKey('fcmToken')) {
//           final fcmToken = data['fcmToken'];
//           if (fcmToken != null && fcmToken is String) {
//             await _sendFCMMessage(fcmToken, title, body);
//           }
//         }
//       }
//     } catch (e) {
//       print('Error sending notification: $e');
//     }
//   }

//   static Future<void> _sendFCMMessage(String token, String title, String body) async {
//     // This requires server-side implementation or Cloud Functions
//     // For now, we'll use Firestore triggers
//     try {
//       await FirebaseFirestore.instance.collection('notifications').add({
//         'token': token,
//         'title': title,
//         'body': body,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error creating notification document: $e');
//     }
//   }
// }

// // Background message handler
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Handling a background message: ${message.messageId}');
// }