import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:movie_db_app/models/movies.dart';

class MovieProvider {
  Client client = Client();
  final _url =
      "https://api.themoviedb.org/3/discover/movie?api_key=6658c1340ed9df0a1b9c6e22b9de4245&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1";

  Future<Movie> fetchMovieList() async{
    final response = await client.get(_url);
    if (response.statusCode == 200) {
      return compute(movieFromJson, response.body);
    } else {
      throw Exception('failed to load data');
    }
  }
}
