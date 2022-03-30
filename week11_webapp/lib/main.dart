import 'dart:html';

import 'package:flutter/material.dart';
import 'data/books_query.dart';
import 'ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My books',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BooksQuery query = BooksQuery();
  List<dynamic> books = [];
  TextEditingController txtSearch = TextEditingController();

  @override
  void initState() {
    query.getBooks('Flutter').then((value) {
      setState(() {
        books = value ?? [];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Books'),
        actions: [
          InkWell(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: isSmall ? const Icon(Icons.home) : const Text('Home')))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              const Text('Search book'),
              Container(
                padding: const EdgeInsets.all(20),
                width: 200,
                child: TextField(
                  controller: txtSearch,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (text) {
                    query.getBooks(text).then((value) {
                      setState(() {
                        books = value ?? [];
                      });
                    });
                  },
                ),
              ),
            ]),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: isSmall
                ? BookList(books: books, favorite: false)
                : BookTable(books: books, favorite: false),
          ),
        ]),
      ),
    );
  }
}
