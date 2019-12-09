import 'dart:io';

import 'package:movie_db_app/models/movies.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = new DBHelper.internal();
  DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await setDB();
    return _db;
  }

  Future<Database> setDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "Movies");

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Movies("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "poster_path VARCHAR(191) NOT NULL,"
        "backdrop_path VARCHAR(191) NOT NULL,"
        "title VARCHAR(191) NOT NULL,"
        "vote_count INTEGER NOT NULL,"
        "overview VARCHAR(191))");
  }

  Future<int> addMovies(Result movie) async {
    var dbClient = await db;
    int count;

    count = await dbClient.insert("Movies", movie.toMapSql());

    return count;
  }

  Future<List<Result>> getAllMovies() async {
    var dbClient = await db;

    var list = await dbClient.query("Movies");
    List<Result> movieList = List<Result>();

    for (var i = 0; i < list.length; i++) {
      movieList.add(Result.fromMapSql(list[i]));
    }

    return movieList;
  }
}
