import 'package:flutter/material.dart';
import 'request.dart';

void main() {
  runApp(const MovieApplication());
}

class MovieApplication extends StatelessWidget {
  const MovieApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upcoming Movies',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Upcoming Movies'),
        ),
        body: const MovieList(),
      ),
    );
  }
}

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List movies = List.empty();

  @override
  Widget build(BuildContext context) {
    MovieRequest.getUpcoming().then(
      (value) {
        setState(() {
          if (value != null) movies = value;
        });
      },
    );
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int position) {
        String title = movies[position].title;
        String releasedDate = movies[position].releaseDate;
        double voteAverage = movies[position].voteAverage;
        return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text(title),
              subtitle: Text('Released: $releasedDate - Vote: $voteAverage'),
            ));
      },
    );
  }
}
