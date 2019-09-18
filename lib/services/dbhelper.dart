import 'dart:async';
import 'dart:io' as io;
import 'package:jtbMusicPlayer/data/listmodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper 
{ 
  static Database _db;
  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String TABLE = 'ListItem';
  static const String DB_NAME = 'listItem.db';
 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $TITLE TEXT)");
  }
 
  Future<ListItem> save(ListItem listItem) async {
    var dbClient = await db;
    listItem.id = await dbClient.insert(TABLE, listItem.toMap());
    return listItem;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }
 
  Future<List<ListItem>> getListItem() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, TITLE]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<ListItem> listItems = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listItems.add(ListItem.fromMap(maps[i]));
      }
    }
    return listItems;
  }
 
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }
 
  Future<int> update(ListItem listItem) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, listItem.toMap(),
        where: '$ID = ?', whereArgs: [listItem.id]);
  }
 
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}

