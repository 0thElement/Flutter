import 'package:flutter/material.dart';

void main() {
  runApp(const HelloWorldTravelApp());
}

class HelloWorldTravelApp extends StatelessWidget {
  const HelloWorldTravelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Hello World Travel Application",
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Hello World Travel"),
              backgroundColor: const Color.fromARGB(99, 137, 45, 243),
            ),
            body: Builder(
              builder: (context) => SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                          child: Column(children: [
                        Text("Hello!",
                            style: TextStyle(
                                fontSize: 40,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[900])),
                        Text("Discover the world",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.normal,
                                color: Colors.blue[700])),
                        Image.network(
                          "https://images.freeimages.com/images/large-previews/eaa/the-beach-1464354.jpg",
                          height: 500,
                        ),
                        ElevatedButton(
                            onPressed: () => onContactPressed(context),
                            child: const Text("Contact us!"))
                      ])))),
            )));
  }
}

void onContactPressed(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Contact us!"),
          content: const Text("Email: hello@world.com"),
          actions: [
            TextButton(
                onPressed: () => {Navigator.of(context).pop()},
                child: const Text("Close"))
          ],
        );
      });
}
