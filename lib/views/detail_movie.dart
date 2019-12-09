import 'package:flutter/material.dart';
import 'package:movie_db_app/models/movies.dart';

class DetailMovie extends StatefulWidget {
  final Result data;
  DetailMovie({Key key, @required this.data}) : super(key: key);
  @override
  _DetailMovieState createState() => _DetailMovieState();
}

class _DetailMovieState extends State<DetailMovie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text('Detail Movie'),
      ),
      body: Container(
        color: Colors.deepPurple,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Image.network(
                  'http://image.tmdb.org/t/p/w185/' + widget.data.backdropPath,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.data.title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.data.overview,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  'http://image.tmdb.org/t/p/w185/' + widget.data.posterPath,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
