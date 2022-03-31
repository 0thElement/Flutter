import 'package:flutter/material.dart';
import 'package:week11_webapp/data/books_favorite.dart';
import 'data/book.dart';

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

class BookTable extends StatefulWidget {
  const BookTable({Key? key, required this.books}) : super(key: key);

  final List<dynamic> books;

  @override
  State<BookTable> createState() => _BookTableState();
}

class _BookTableState extends State<BookTable> {
  Set<String> favorites = {};

  void initialize() async {
    favorites = await BooksFavorite().getFavoriteKeys();

    setState(() {
      favorites = favorites;
    });
  }

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
      children: widget.books.map((book) {
        return TableRow(children: [
          TableCell(child: TableText(text: book.title)),
          TableCell(child: TableText(text: book.authors)),
          TableCell(child: TableText(text: book.publisher)),
          TableCell(
              child: FavoriteIcon(
            book: book,
            favorite: favorites.contains(book),
          )),
        ]);
      }).toList(),
    );
  }
}

class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({
    Key? key,
    required this.book,
    required this.favorite,
  }) : super(key: key);

  final Book book;
  final bool favorite;

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool favorite = false;

  @override
  void initState() {
    favorite = widget.favorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.star),
        onPressed: () {
          if (favorite) {
            BooksFavorite().deleteFromFavorites(widget.book, () {
              setState(() {
                favorite = false;
              });
            });
          } else {
            BooksFavorite().addToFavorites(widget.book, () {
              setState(() {
                favorite = true;
              });
            });
          }
        },
        tooltip: (favorite) ? 'Remove from favorites' : 'Add to favorites',
        color: (favorite) ? Colors.amber : Colors.grey);
  }
}

class BookList extends StatefulWidget {
  const BookList({Key? key, required this.books}) : super(key: key);

  final List<dynamic> books;

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  Set<String> favorites = {};

  void initialize() async {
    favorites = await BooksFavorite().getFavoriteKeys();

    setState(() {
      favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      child: ListView.builder(
          itemCount: widget.books.length,
          itemBuilder: (_, i) => ListTile(
              title: Text(widget.books[i].title),
              subtitle: Text(widget.books[i].authors),
              trailing: FavoriteIcon(
                book: widget.books[i],
                favorite: favorites.contains(widget.books[i]),
              ))),
    );
  }
}
