import 'package:flutter/material.dart';
import 'package:supermarche_abc/models/user.dart';

/* class UserDatabase {
  //private constructor
  UserDatabase._();

  static final UserDatabase instance = UserDatabase._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'user_database.db');

    WidgetsFlutterBinding.ensureInitialized();
    //await db.close();
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        return await db.execute('CREATE TABLE user(id INT PRIMARY KEY, username TEXT, email TEXT, password TEXT)');
      },
    );
  }

  void insertUser(User user) async {
    final Database db = await database;
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateUser(User user) async {
    final Database db = await database;
    await db.update(
      'user',
      user.toMap(),
      where: 'email = ?',
      whereArgs: [user.email],
    );
  }

  void deleteUser(User user) async {
    final Database db = await database;
    await db.delete(
      'user',
      where: 'email = ?',
      whereArgs: [user.email],
    );
  }

  Future<List<User>> selectUsers() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    List<User> users = List.generate(
      maps.length,
      (i) => User.fromMap(maps[i]),
    );

    /* if (users.isEmpty) {
      for (User user in defaultUser) {
        insertUser(user);
      }
      users = defaultUser;
    } */
    return users;
  }

  /* final List<User> defaultUser = [
    User(
      'supermarche',
      'superabc@abc.com',
      'abcAdmin',
    ),
  ]; */
} */
