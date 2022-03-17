import 'dart:convert';

import 'package:http/http.dart' as http;

class Movie {
  int? id;
  String? title;
  double? voteAverage;
  String? releaseDate;
  String? overview;
  String? posterPath;

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
  static const String urlBase = 'https://api.themoviedb.org/3/movie';
  static const String urlSearchBase =
      'https://api.themoviedb.org/3/search/movie?';
  static const String upcoming = '/upcoming?';
  static const String apiKey = 'api_key=6b03363fc5aeb3e668286709d7136e6d';
  static const String language = '&language=en-US';
  static const String query = '&query=';
  static const String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  static const String iconUrl = 'https://image.tmdb.org/t/p/w92';
  static const String iconLargeUrl = 'https://image.tmdb.org/t/p/w500';

  static Future<List?> getUpcoming() async {
    const String upcomingUrl = urlBase + upcoming + apiKey + language;
    http.Response result = await http.get(Uri.parse(upcomingUrl));

    if (result.statusCode == 200) {
      return parse(result.body);
    }
    return null;
  }

  static Future<List?> searchMovies(String search) async {
    String searchUrl = urlSearchBase + apiKey + query + search;
    http.Response result = await http.get(Uri.parse(searchUrl));

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

  static String posterUrl(Movie movie, {bool large = false}) {
    if (movie.posterPath == null) return defaultImage;
    return (large ? iconLargeUrl : iconUrl) + movie.posterPath!;
  }
}
