import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Setting up DB
class DBHelper {
  DBHelper._privateConstructor();

  static DBHelper dbHelper = DBHelper._privateConstructor();

  late Database _database;

  Future<Database> get database async {
    _database = await _createDatabase();
    return _database;
  }

//Creating the database
  Future<Database> _createDatabase() async {
    Database database =
        await openDatabase(join(await getDatabasesPath(), 'mydb.db'),
            onCreate: (Database db, int version) {
      db.execute("CREATE TABLE Information(" +
          "id INTEGER PRIMARY KEY, " +
          "city TEXT,   " +
          "country TEXT," +
          "email TEXT," +
          "firstName TEXT," +
          "lastName TEXT," +
          "password TEXT," +
          // "profilePic TEXT," + figure out a way to incorporate this
          "province TEXT" +
          ")");
    }, version: 1);
    return database;
  }

  //Calling the database
  Future<List<Map<String, dynamic>>> getAllInfo() async {
    Database db = await database;
    return await db.query("Information");
  }

  //If time is permissible setup an edit function for profile page
  // //Inserting new rows into the db
  Future<int> insertUserInfo(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert("Information", row);
  }

  Future<int> delete(String password) async {
    Database db = await database;
    return await db.delete("Information",where: "password=?",whereArgs:[password]);
  }
}
