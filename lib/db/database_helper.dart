import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:listasqflite/model/item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'lista_compras.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        quantidade INTEGER,
        status INTEGER
      )
    ''');
  }

  Future<int> insertItem(Item item) async {
    Database db = await database;
    return await db.insert('items', item.toMap());
  }

  Future<List<Item>> getItems() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) => Item.fromMap(maps[i]));
  }

   Future<int> deleteItem(int? id) async {
    Database db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
   Future<int> updateItemStatus(Item item) async {
    Database db = await database;
    return await db.update(
      'itens',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}

