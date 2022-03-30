class Book {
  String? id;
  String title;
  String authors;
  String description;
  String publisher;

  Book(this.id, this.title, this.authors, this.description, this.publisher);

  factory Book.fromJson(Map<String, dynamic> json) {
    final String id = json['id'];
    final String title = json['volumeInfo']['title'];
    final String authors = json['volumeInfo']['authors']
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');

    final String description = json['volumeInfo']['description'] ?? '';
    final String publisher = json['volumeInfo']['publisher'] ?? '';

    return Book(id, title, authors, description, publisher);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'publisher': publisher
    };
  }
}
