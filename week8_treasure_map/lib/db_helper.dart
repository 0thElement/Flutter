import 'package:sqflite/sqflite.dart';
import './place.dart';
import 'package:path/path.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  Future<Database> openDb() async {
    db ??= await openDatabase(join(await getDatabasesPath(), 'mapp.db'),
        onCreate: ((db, version) => db.execute('''
          CREATE TABLE places(id INTEGER PRIMARY KEY, name TEXT, lat DOUBLE, 
          lon DOUBLE, image TEXT)''')), version: version);
    return db!;
  }

  Future insertMockData() async {
    db = await openDb();

    await db!.execute('''
      DELETE FROM places;
    ''');
    await db!.execute('''
      INSERT INTO places VALUES (1, "Beautiful park", 41.9294115, 12.5380785, "");
    ''');
    await db!.execute('''
      INSERT INTO places VALUES (2, "Best pizza in the world", 41.9294115, 12.5268947, "");
    ''');
    await db!.execute('''
      INSERT INTO places VALUES (3, "The best icecream on earth", 41.9349061, 12.5339831, "");
    ''');
  }

  Future<List<Place>> getPlaces() async {
    db = await openDb();
    final List<Map<String, dynamic>> maps = await db!.query('places');
    // if (maps == null) return [];

    return List.generate(
        maps.length,
        (i) => Place(
              maps[i]['id'],
              maps[i]['name'],
              maps[i]['lat'],
              maps[i]['lon'],
              maps[i]['image'],
            ));
  }

  Future<int> insertPlace(Place place) async {
    db = await openDb();
    int id = await db!.insert('places', place.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> deltePlace(Place place) async {
    db = await openDb();
    int id = await db!.delete('places', where: "id = ?", whereArgs: [place.id]);
    return id;
  }

  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }
}
