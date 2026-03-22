import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  late Database database;
  Future<String> setDatabasePath() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'chat.db');
    return path;
  }

  Future<Database> createDatabase() async {
    String path = await setDatabasePath();
    print("----------------------Database is created $path");
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE Chat(
            conversation_id TEXT, 
            unread_message_count INTEGER,
            last_message TEXT, 
            created_at TEXT, 
            user TEXT)
            ''');
      },
    );
    print(
        "############################### This is the database ${database.path}");
    return database;
  }
}
