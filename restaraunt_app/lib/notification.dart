import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:restaraunt_app/homepage.dart';
import 'package:restaraunt_app/profile_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'timeformat.dart';

class MyNotification{
  BuildContext context;
  late FlutterLocalNotificationsPlugin notification;
  String reservationTime = "";
  String restaurantName = "";
  MyNotification(this.context){
    initNotification();
  }

//initalize notification
  initNotification(){
    tz.initializeTimeZones();
    notification = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings);
    notification.initialize(initializationSettings,
    );
  }


  //show notification function 
  Future showNotification(int hour, String restaurant, String reservation)async{
    var androidNotification = AndroidNotificationDetails("channelId", "channelName",priority: Priority.high,importance: Importance.max);
    var notificationDetails = NotificationDetails(android: androidNotification);
    //get current time
    var now = DateTime.now();
    //if reservation is within the hour show immediately
    if(now.hour == hour-1){
      reservationTime = reservation;
      restaurantName = restaurant;
      await notification.show(
	        101,
	        "Your Reservation",
	        "${formatTime().timeFormat(reservation)} at $restaurant",
	        notificationDetails,
          );

    //if reservation is in the future schedual notification to hour before reservation
    }else if(now.hour < hour){
      reservationTime = reservation;
      restaurantName = restaurant;
      await notification.zonedSchedule(
	        101,
	        "Your Reservation",
	        "${formatTime().timeFormat(reservation)} at $restaurant",
	        tz.TZDateTime.from(DateTime(now.year,now.month,now.day,hour-1,0,0,0,0), tz.local)
	            .add(const Duration(seconds: 0)),
	        notificationDetails,
	        uiLocalNotificationDateInterpretation:
	            UILocalNotificationDateInterpretation.absoluteTime,
	        androidAllowWhileIdle: true);

    //else do nothing
    }else{
      
    }
  }

  
}