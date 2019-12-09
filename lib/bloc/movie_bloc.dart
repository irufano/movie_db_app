import 'package:movie_db_app/database/db_helper.dart';
import 'package:movie_db_app/models/movies.dart';
import 'package:movie_db_app/repository/movie_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class MovieBloc {
  DBHelper _dbHelper = new DBHelper();
  final _movieRepository = MovieRepository();
  final _movieFetcher = PublishSubject<Movie>();
  final _movieListFetcher = PublishSubject<List<Result>>();
  final _movieListSqlFetcher = PublishSubject<List<Result>>();

  Observable<Movie> get movieResponse => _movieFetcher.stream;
  Observable<List<Result>> get listMovie => _movieListFetcher.stream;
  Observable<List<Result>> get listMovieSql => _movieListSqlFetcher.stream;

  fetchMovie() async {
    var movie = await _movieRepository.fetchMovie();
    _movieFetcher.sink.add(movie);
    _movieListFetcher.sink.add(movie.results);
  }

  fetchMovieSql() async {
    var movie = await _dbHelper.getAllMovies();
    _movieListSqlFetcher.sink.add(movie);
    _movieListFetcher.sink.add(movie);
  }

  dispose() {
    _movieFetcher.close();
    _movieListFetcher.close();
    _movieListSqlFetcher.close();
  }
}

final movieBLoc = MovieBloc();
