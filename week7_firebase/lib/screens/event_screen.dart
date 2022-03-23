import 'package:flutter/material.dart';
import 'package:week7_firebase/models/event_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_firebase/models/favorite.dart';
import 'package:week7_firebase/screens/login_screen.dart';
import 'package:week7_firebase/shared/authentication.dart';
import 'package:week7_firebase/shared/firestore_helper.dart';

class EventScreen extends StatelessWidget {
  const EventScreen(this.userId, {Key? key}) : super(key: key);

  final String userId;

  void signOut(BuildContext context) async {
    Authentication().signOut().then((result) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
        actions: [
          IconButton(
              onPressed: () => signOut(context),
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: EventList(userId),
    );
  }
}

class EventList extends StatefulWidget {
  const EventList(this.userId, {Key? key}) : super(key: key);
  final String userId;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<EventDetail> details = [];
  List<Favorite> favorites = [];

  Future<List<EventDetail>> getDetailsList() async {
    var data = await db.collection('event_details').get();
    details = data.docs.map((e) => EventDetail.fromMap(e)).toList();
    int i = 0;
    details.forEach((element) {
      element.id = data.docs[i].id;
    });
    return details;
  }

  @override
  void initState() {
    if (mounted) {
      getDetailsList().then((data) {
        setState(() {
          details = data;
        });
      });

      FirestoreHelper.getUserFavorites(widget.userId).then((value) {
        setState(() {
          favorites = value;
        });
      });
    }
    super.initState();
  }

  bool isUserFavorite(String? eventId) {
    return favorites.any((element) => element.eventId == eventId);
  }

  void toggleFavorite(EventDetail event) async {
    if (isUserFavorite(event.id)) {
      Favorite fav = favorites.firstWhere((f) => f.eventId == event.id);
      if (fav.id != null) {
        FirestoreHelper.deleteFavorite(fav.id!);
      }
    } else {
      FirestoreHelper.addFavorite(event, widget.userId);
    }

    FirestoreHelper.getUserFavorites(widget.userId).then((value) {
      setState(() {
        favorites = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: details.length,
        itemBuilder: (context, position) {
          EventDetail item = details[position];
          bool isFav = isUserFavorite(details[position].id);
          Color starColor = (isFav ? Colors.amber : Colors.grey);
          return ListTile(
            title: Text(item.description ?? ""),
            subtitle: Text(
                "Date: ${item.date} - Start: ${item.startTime} - End: ${item.endTime}"),
            trailing: IconButton(
              icon: Icon(Icons.star, color: starColor),
              onPressed: () {
                toggleFavorite(details[position]);
              },
            ),
          );
        });
  }
}
