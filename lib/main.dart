import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'book.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}
class _BookListScreenState extends State<BookListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Book> _books = [];

  // Memuat data buku dari database
  void _loadBooks() async {
    List<Book> books = await _dbHelper.getBooks();
    setState(() {
      _books = books;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  // Menampilkan dialog untuk menambah buku baru
  void _showAddBookDialog() {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Buku'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul Buku'),
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Penulis'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newBook = Book(
                  title: titleController.text,
                  author: authorController.text,
                );
                await _dbHelper.insertBook(newBook);
                Navigator.pop(context);
                _loadBooks();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan dialog untuk mengedit buku
  void _showEditBookDialog(Book book) {
    final titleController = TextEditingController(text: book.title);
    final authorController = TextEditingController(text: book.author);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Buku'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul Buku'),
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Penulis'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedBook = Book(
                  id: book.id,
                  title: titleController.text,
                  author: authorController.text,
                );
                await _dbHelper.updateBook(updatedBook);
                Navigator.pop(context);
                _loadBooks();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan dialog konfirmasi untuk menghapus buku
  void _showDeleteConfirmationDialog(Book book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Buku'),
          content: Text('Apakah Anda yakin ingin menghapus buku ini?'),
          actions: [
            TextButton(
              onPressed: () async {
                await _dbHelper.deleteBook(book.id!);
                Navigator.pop(context);
                _loadBooks();
              },
              child: Text('Hapus'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pencatatan Buku')),
      body: ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditBookDialog(book), // Edit buku
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      _showDeleteConfirmationDialog(book), // Hapus buku
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog, // Tambah buku
        child: Icon(Icons.add),
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(
    home: BookListScreen(),
  ));
}