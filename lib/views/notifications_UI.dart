import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_ease/models/notification_model.dart';

class NotificationsUI extends StatelessWidget {
  NotificationsUI({super.key});

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> removeNotification(NotificationModel notification) async {
    try {
      // Delete notification document from Firestore
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notification.notificationID)
          .delete();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userID', isEqualTo: userId)
            .orderBy('notificationDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var notifications = snapshot.data!.docs.map(
              (doc) {
                var data = doc.data() as Map<String, dynamic>;
                return NotificationModel(
                    userID: data['userID'],
                    message: data['message'],
                    notificationID: data['notificationID'],
                    notificationDate: data['notificationDate'].toDate());
              },
            ).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  var notification = notifications[index];

                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Card(
                        elevation: 0,
                        color: Colors.grey[200],
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(notification.message),
                          subtitle: Text(
                            '${_formattedDate(notification.notificationDate)}',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              removeNotification(notification);
                            },
                          ),
                        ),
                      ));
                },
              ),
            );
          }
        },
      ),
    );
  }

  String _formattedDate(DateTime date) {
    return '${date.month}-${date.day}-${date.year}  |  ${date.hour}:${date.minute}';
  }
}
