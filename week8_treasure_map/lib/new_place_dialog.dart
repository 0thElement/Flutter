import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'place.dart';

class PlaceDialog {
  PlaceDialog(this.place, this.isNewPlace, this.onEditComplete);

  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtLat = TextEditingController();
  final TextEditingController txtLon = TextEditingController();

  final bool isNewPlace;
  final Place place;
  final VoidCallback onEditComplete;

  Widget buildDialog(BuildContext context) {
    DbHelper helper = DbHelper();
    txtName.text = place.name;
    txtLat.text = place.lat.toString();
    txtLon.text = place.lon.toString();
    return AlertDialog(
        title: const Text('New Place'),
        content: SingleChildScrollView(
            child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: txtLat,
              decoration: const InputDecoration(hintText: 'Latitude'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: txtLon,
              decoration: const InputDecoration(hintText: 'Longitude'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextButton(
                onPressed: () {
                  place.name = txtName.text;
                  place.lat = double.tryParse(txtLat.text) ?? 0;
                  place.lon = double.tryParse(txtLon.text) ?? 0;
                  helper.insertPlace(place);
                  Navigator.pop(context);
                  onEditComplete();
                },
                child: const Text('OK'))
          ],
        )));
  }
}
