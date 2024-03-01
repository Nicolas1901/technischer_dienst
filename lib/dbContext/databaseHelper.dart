import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final DatabaseHelper _databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  late Database db;

  factory DatabaseHelper(){
    return _databaseHelper;
  }

  initDb() async{
    //TODO use path_provider for IOS devices
    String path = await getDatabasesPath();

    db = await openDatabase(join(path, "techDienst.db"),
    onCreate: (database, version) async{
      await database.execute(
        """
          CREATE TABLE templates(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            image TEXT,
            categories STRING
          ),
          CREATE TABLE reports(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            reportName TEXT NOT NULL,
            inspector TEXT NOT NULL,
            template TEXT NOT NULL,
            date STRING,
            categories STRING
          ),
        
        """,
      );
    });

  }
}