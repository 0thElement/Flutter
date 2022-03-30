import 'book.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

class BooksQuery {
  final String urlBase = 'https://www.googleapis.com/books/v1/';
  final String urlQuery = 'volumes?q=';
  final String urlKey = '&key=AIzaSyD88KidVn-zTRcKnueOnIDxx7tA7cdSadc';

  Future<List<dynamic>?> getBooks(String query) async {
    final String url = urlBase + urlQuery + query + urlKey;
    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final booksMap = json['items'];
      return booksMap.map((item) => Book.fromJson(item)).toList();
    } else {
      return null;
    }
  }
}
