import 'package:flutter/material.dart';
import 'package:week7_firebase/shared/authentication.dart';

import 'login_screen.dart';
import 'event_screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Authentication auth = Authentication();
    auth.getUser().then((user) {
      MaterialPageRoute route;

      if (user != null) {
        route = MaterialPageRoute(builder: (context) => EventScreen(user.uid));
      } else {
        route = MaterialPageRoute(builder: (context) => const LoginScreen());
      }

      Navigator.pushReplacement(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
