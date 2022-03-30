import 'package:flutter/material.dart';
import 'data/books_query.dart';

class TableText extends StatelessWidget {
  const TableText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).primaryColorDark),
      ),
    );
  }
}

class BookTable extends StatelessWidget {
  const BookTable({Key? key, required this.books, required this.favorite})
      : super(key: key);

  final List<dynamic> books;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.blueGrey),
      children: books.map((book) {
        return TableRow(children: [
          TableCell(child: TableText(text: book.title)),
          TableCell(child: TableText(text: book.authors)),
          TableCell(child: TableText(text: book.publisher)),
          TableCell(child: FavoriteIcon(favorite: favorite)),
        ]);
      }).toList(),
    );
  }
}

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({
    Key? key,
    required this.favorite,
  }) : super(key: key);

  final bool favorite;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.star),
        onPressed: () {},
        tooltip: (favorite) ? 'Remove from favorites' : 'Add to favorites',
        color: (favorite) ? Colors.grey : Colors.amber);
  }
}

class BookList extends StatelessWidget {
  const BookList({Key? key, required this.books, required this.favorite})
      : super(key: key);

  final List<dynamic> books;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (_, i) => ListTile(
              title: Text(books[i].title),
              subtitle: Text(books[i].authors),
              trailing: FavoriteIcon(favorite: favorite))),
    );
  }
}
