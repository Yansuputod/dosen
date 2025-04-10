class Book {
  int? id;
  String title;
  String author;
  Book({this.id, required this.title, required this.author});
// Mengonversi objek Book menjadi map (untuk menyimpan ke SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
    };
  }

  // Mengonversi map menjadi objek Book
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
    );
  }
}