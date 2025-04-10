import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'book.dart'; // Import model Book

class DatabaseHelper {
  static Database? _database;

  // Singleton pattern untuk mendapatkan satu instance database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'books.db');
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE books( 
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          title TEXT, 
          author TEXT 
        ) 
      ''');
    });
  }

  // CREATE: Menambahkan buku ke database
  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert('books', book.toMap());
  }

  // READ: Mengambil semua buku dari database
  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  // UPDATE: Memperbarui data buku
  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  // DELETE: Menghapus buku berdasarkan id
  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}