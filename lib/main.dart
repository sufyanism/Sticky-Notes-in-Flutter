import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sticky_notes_app/services/notification_service.dart';
import 'package:sticky_notes_app/views/homes_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService();
  runApp(const StickyNotesApp());
}

class StickyNotesApp extends StatelessWidget {
  const StickyNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sticky Notes',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomeScreen(),

    );
  }
}

