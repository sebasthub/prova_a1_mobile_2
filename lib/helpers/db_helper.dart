import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        price REAL,
        imageUrl TEXT,
        contact TEXT,
        isActive INTEGER,
        isMine INTEGER
      )
    ''');
    
    // Seed database with mock items if created for the first time
    final seedItems = [
      Item(
        id: '1',
        title: 'Bicicleta Caloi Aro 29',
        description: 'Bicicleta em ótimo estado, pouco uso.',
        price: 650.0,
        imageUrl: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&q=80&w=400',
        contact: '(11) 99999-9999',
      ),
      Item(
        id: '2',
        title: 'Sofá 3 Lugares',
        description: 'Sofá retrátil e reclinável.',
        price: 800.0,
        imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&q=80&w=400',
        contact: '(11) 98888-8888',
      ),
      Item(
        id: '3',
        title: 'Livros de Programação',
        description: 'Doação de livros de Java e Python.',
        price: 0.0,
        imageUrl: 'https://images.unsplash.com/photo-1532012197267-da84d127e765?auto=format&fit=crop&q=80&w=400',
        contact: '(11) 97777-7777',
      ),
      Item(
        id: '4',
        title: 'Monitor Dell 24"',
        description: 'Monitor Full HD com ajuste de altura.',
        price: 450.0,
        imageUrl: 'https://images.unsplash.com/photo-1527443154391-507e9dc6c5cc?auto=format&fit=crop&q=80&w=400',
        contact: '(11) 96666-6666',
      ),
      Item(
        id: '5',
        title: 'Geladeira Brastemp',
        description: 'Geladeira Frost Free branca. Gelando muito!',
        price: 1200.0,
        imageUrl: 'https://images.unsplash.com/photo-1584568694244-14fbdf83bd30?auto=format&fit=crop&q=80&w=400',
        contact: '(11) 95555-5555',
      ),
      Item(
        id: '6',
        title: 'Roupas Infantis',
        description: 'Lote de roupas para bebê de 0 a 6 meses. Doação.',
        price: 0.0,
        imageUrl: 'https://images.unsplash.com/photo-1522771930-78848d928718?auto=format&fit=crop&q=80&w=400',
        contact: '(11) 94444-4444',
      ),
      Item(
        id: '7',
        title: 'Mesa de Escritório',
        description: 'Mesa em L, cor madeira clara.',
        price: 200.0,
        imageUrl: 'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?auto=format&fit=crop&q=80&w=400',
        contact: '(11) 93333-3333',
      ),
    ];
    
    for (var item in seedItems) {
      await db.insert('items', item.toMap());
    }
  }

  Future<void> insertItem(Item item) async {
    final db = await database;
    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Item>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');

    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<void> updateItem(Item item) async {
    final db = await database;
    await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteItem(String id) async {
    final db = await database;
    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
