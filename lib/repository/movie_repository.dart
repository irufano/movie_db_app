import 'package:movie_db_app/models/movies.dart';
import 'package:movie_db_app/providers/movie_provider.dart';

class MovieRepository{
  final movieProvider = MovieProvider();


  Future<Movie> fetchMovie() => movieProvider.fetchMovieList();

}