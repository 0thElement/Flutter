import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_detail.dart';
import '../models/favorite.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future addFavorite(EventDetail event, String userId) {
    Favorite fav = Favorite(null, event.id, userId);
    return db.collection('favorites').add(fav.toMap());
  }

  static Future deleteFavorite(String id) {
    return db.collection('favorites').doc(id).delete();
  }

  static Future<List<Favorite>> getUserFavorites(String uid) async {
    var docs =
        await db.collection('favorites').where('userId', isEqualTo: uid).get();

    return docs.docs.map((data) => Favorite.map(data)).toList();
  }
}
