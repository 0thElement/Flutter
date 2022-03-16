import 'dart:convert';

import 'package:http/http.dart' as http;

class Movie {
  late int id;
  late String title;
  late double voteAverage;
  late String releaseDate;
  late String overview;
  late String posterPath;

  Movie(this.id, this.title, this.voteAverage, this.releaseDate, this.overview,
      this.posterPath);

  Movie.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    title = parsedJson['title'];
    voteAverage = parsedJson['vote_average'] * 1.0;
    releaseDate = parsedJson['release_date'];
    overview = parsedJson['overview'];
    posterPath = parsedJson['poster_path'];
  }
}

class MovieRequest {
  static const String apiKey = 'api_key=6b03363fc5aeb3e668286709d7136e6d';
  static const String urlBase = 'https://api.themoviedb.org/3/movie';
  static const String upcoming = '/upcoming?';
  static const String language = '&language=en-US';

  static Future<List?> getUpcoming() async {
    const String upcomingUrl = urlBase + upcoming + apiKey + language;
    http.Response result = await http.get(Uri.parse(upcomingUrl));

    if (result.statusCode == 200) {
      return parse(result.body);
    }
    return null;
  }

  static List parse(String json) {
    final jsonResponse = jsonDecode(json);
    final moviesMap = jsonResponse['results'];
    return moviesMap.map((item) => Movie.fromJson(item)).toList();
  }
}
