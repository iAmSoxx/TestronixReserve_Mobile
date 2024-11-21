import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tronixbook_project/pages/login_page.dart';
import 'package:tronixbook_project/pages/registration_page.dart';
import 'pages/room_page.dart';
import 'providers/booking_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => BookingProvider()), // New Provider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/loginPage',
      routes: {
        '/loginPage': (context) => const LoginPage(),
        'registrationPage': (context) => const RegistrationPage(),
        'roomPage': (context) => RoomPage(),
      },
    );
  }
}
