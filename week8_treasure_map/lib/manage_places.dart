import 'package:flutter/material.dart';
import 'package:week8_treasure_map/new_place_dialog.dart';
import 'db_helper.dart';
import 'place.dart';

class ManagePlaces extends StatelessWidget {
  const ManagePlaces(this.refreshList, {Key? key}) : super(key: key);

  final VoidCallback refreshList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage places')),
      body: PlacesList(refreshList),
    );
  }
}

class PlacesList extends StatefulWidget {
  const PlacesList(this.refreshList, {Key? key}) : super(key: key);

  final VoidCallback refreshList;

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  DbHelper helper = DbHelper();
  List<Place> places = [];

  void refreshList() {
    helper.getPlaces().then((value) => {
          setState(() {
            places = value;
          })
        });
    widget.refreshList();
  }

  @override
  void initState() {
    refreshList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, i) {
        return Dismissible(
          key: Key(places[i].name),
          onDismissed: (direction) {
            String name = places[i].name;
            helper.deltePlace(places[i]);
            setState(() {
              places.removeAt(i);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$name deleted")));
            });
            widget.refreshList();
          },
          child: ListTile(
              title: Text(places[i].name),
              trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            PlaceDialog(places[i], false, refreshList)
                                .buildDialog(context));
                  })),
        );
      },
    );
  }
}
