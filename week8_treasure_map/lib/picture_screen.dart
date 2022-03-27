import 'dart:io';
import 'package:flutter/material.dart';
import 'place.dart';
import 'db_helper.dart';
import 'main.dart';

class PictureScreen extends StatelessWidget {
  const PictureScreen(this.imagePath, this.place, {Key? key}) : super(key: key);

  final String imagePath;
  final Place place;

  @override
  Widget build(BuildContext context) {
    final DbHelper helper = DbHelper();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Save picture'),
        actions: [
          IconButton(
              onPressed: () {
                place.image = imagePath;
                helper.insertPlace(place);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Container(child: Image.file(File(imagePath))),
    );
  }
}
