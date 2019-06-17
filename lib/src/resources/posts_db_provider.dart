import 'dart:async';
import 'dart:io';

import '../resources/posts_api_provider.dart';

import '../models/post_model.dart';
import 'repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:queries/collections.dart';
import 'package:queries/queries.dart';

int _mypage$count = 1;

class PostsDbProvider implements Source, Cache {
  static final _databaseName = "Chroniques_1.db";
  static final _databaseVersion = 1;
  static final table = 'Posts';

  // make this a singleton class
  PostsDbProvider._privateConstructor();
  static final PostsDbProvider instance = PostsDbProvider._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

// this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute("""CREATE TABLE Posts(
            id INTEGER PRIMARY KEY
            , date TEXT
            , title TEXT
            ,content TEXT
            ,excerpt TEXT
            ,author TEXT
            ,featuredMedia INTEGER
            ,featuredMediaUrl TEXT
            ,link TEXT
            ,categories BLOB
        )""");
  }

  // Todo - store and fetch top ids
  Future<List<int>> fetchTopIds() {
    return null;
  }

  Future<bool> close() async {
    Database db = await instance.database;
    db.close();
    return true;
  }

  Future<int> clear() async {
    Database db = await instance.database;
    return db.delete("Posts");
  }

  @override
  Future<int> addPosts(int category, List<Post> posts) async {
    int nbRecords = 0;
    int nbTotalRecords = 0;
    posts.forEach((post) async {
      nbRecords = await insertPost(post) ?? 0;
      nbTotalRecords = nbTotalRecords + nbRecords;
    });
    // for (var post in posts) {
    //   nbRecords = await insertPost(post) ?? 0;

    //   nbTotalRecords = nbTotalRecords + nbRecords;
    // }
    return nbTotalRecords;
  }

  @override
  Future<List<Post>> fetchDataCat(int category, int page) async {
    List<Post> posts;

    var queryResponse = await instance.queryAllPosts();
    posts = queryResponse.map((parsedJson) => Post.fromDb(parsedJson)).toList();
    print('dbRead before filter #posts : ' + (posts.length).toString());
    var catposts = posts.where((l) => l.categories.contains(category)).toList();
    posts = catposts.toSet().toList();
    // var ncatposts = new Collection(posts).distinct();

    // posts=ncatposts as List<Post>;
    print('dbRead #posts : ' + (posts.length).toString());

    if (posts.length > 0) {
      return posts;
    }
    return null;
  }

  @override
  Future<List<Post>> fetchDataSearch(String searchText, int page) {
    // TODO: implement fetchDataSearch
    return null;
  }

  Future<int> insertPost(Post post) async {
    Database db = await instance.database;
    var postMap = post.toMap();
    return await db.insert(
      'Posts',
      postMap,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> updatePost(Post post) async {
    Database db = await instance.database;
    int id = post.id;
    return await db
        .update('Posts', post.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllPosts() async {
    Database db = await instance.database;
    //  return await db.query('Posts');
    // return await db.query('Posts',  orderBy: "date DESC");
    return await db.rawQuery("SELECT * FROM Posts order By date DESC");
    //Cursor cc = db.rawQuery("select col1 from table where col2=? and col3=?",new String[] { "value for col2", "value for col3" });
  }

  Future<int> deletePosts(int id) async {
    Database db = await instance.database;
    return await db.delete('Posts', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllPosts() async {
    Database db = await instance.database;
    return await db.delete('Posts', where: null, whereArgs: null);
  }

  Future<bool> deleteDb({String path}) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    await deleteDatabase(path);
    return true;
  }

  Future<bool> dropTable({String table}) async {
    Database db = await instance.database;
    await db.rawQuery(' DROP TABLE IF EXISTS Posts');
    return true;
  }

  Future<int> insertOrReplacePost(Post post) async {
    Database db = await instance.database;

    int rowcount = await postsDbProvider.updatePost(post);
    if (rowcount == 0) {
      return await postsDbProvider.insertPost(post);
    } else {
      return rowcount;
    }
  }

  void dropTablePosts() async {
    // Assuming that the number of rows is the id for the last row.

    var response = await postsDbProvider.dropTable();
    print('Table Posts dropped : ' + response.toString());
  }

  PostsApiProvider postApiProvider = PostsApiProvider();

  Future<bool> apiRead() async {
    Database db = await instance.database;
    var page = _mypage$count++;
    print('apiRead #page : ' + page.toString());
    var posts = await postApiProvider.fetchDataCat(1, page);
    print('apiRead #posts : ' + (posts.length).toString());
    for (var post in posts) {
      postsDbProvider.insertOrReplacePost(post);
    }
    return true;
  }
}

//PostsDbProvider postDbProvider = PostsDbProvider();
final postsDbProvider = PostsDbProvider.instance;
