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
      home: const MovieList(),
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

  Icon searchIcon = const Icon(Icons.search);
  Widget searchBar = const Text('Upcoming Movies');

  void openMovieDetail(BuildContext context, Movie movie) {
    MaterialPageRoute route =
        MaterialPageRoute(builder: (_) => MovieDetail(movie));
    Navigator.push(context, route);
  }

  @override
  void initState() {
    showUpcoming();
    super.initState();
  }

  void showUpcoming() {
    MovieRequest.getUpcoming().then(
      (value) {
        setState(() {
          if (value != null) movies = value;
        });
      },
    );
  }

  void searchText(String text) {
    setState(() {
      MovieRequest.searchMovies(text).then(
        (value) {
          setState(() {
            if (value != null) movies = value;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: searchBar, actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (searchIcon.icon == Icons.search) {
                    searchIcon = const Icon(Icons.cancel);
                    searchBar = TextField(
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      onSubmitted: (String text) {
                        searchText(text);
                      },
                    );
                  } else {
                    searchIcon = const Icon(Icons.search);
                    searchBar = const Text('Upcoming Movies');
                    showUpcoming();
                  }
                });
              },
              icon: searchIcon)
        ]),
        body: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int position) {
            String title = movies[position].title;
            String releasedDate = movies[position].releaseDate;
            double voteAverage = movies[position].voteAverage;
            String networkImage = MovieRequest.posterUrl(movies[position]);
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                title: Text(title),
                subtitle: Text('Released: $releasedDate - Vote: $voteAverage'),
                leading:
                    CircleAvatar(backgroundImage: NetworkImage(networkImage)),
                onTap: () => openMovieDetail(context, movies[position]),
              ),
            );
          },
        ));
  }
}

class MovieDetail extends StatelessWidget {
  const MovieDetail(this.movie, {Key? key}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title ?? 'NaN'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all((16)),
            child: Text(movie.overview ?? 'No description'),
          ),
          Container(
              padding: const EdgeInsets.all(16),
              height: height / 1.5,
              child: Image.network(
                MovieRequest.posterUrl(movie, large: true),
              ))
        ],
      )),
    );
  }
}
