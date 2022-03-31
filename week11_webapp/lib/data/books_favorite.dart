import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'book.dart';

class BooksFavorite {
  Future addToFavorites(Book book, VoidCallback onComplete) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (book.id == null) return;
    await preferences.setString(book.id!, json.encode(book.toMap()));
    onComplete.call();
  }

  Future deleteFromFavorites(Book book, VoidCallback onComplete) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (book.id == null) return;
    String? id = preferences.getString(book.id!);
    if (id == null) return;
    await preferences.remove(book.id!);
    onComplete.call();
  }

  Future<List<dynamic>> getFavorites() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Set allKeys = preferences.getKeys();
    List<dynamic> books = [];
    for (var key in allKeys) {
      String val = preferences.getString(key)!;
      dynamic json = jsonDecode(val);
      Book book = Book(json['id'], json['title'], json['authors'],
          json['description'], json['publisher']);
      books.add(book);
    }
    return books;
  }

  Future<Set<String>> getFavoriteKeys() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getKeys();
  }
}
