import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:movie_db_app/bloc/movie_bloc.dart';
import 'package:movie_db_app/database/db_helper.dart';
import 'package:movie_db_app/models/movies.dart';
import 'package:movie_db_app/views/detail_movie.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<List<Result>> stream;

  @override
  void initState() {
    checkConectivity();
    super.initState();
  }

  checkConectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      movieBLoc.fetchMovieSql();
      //stream = movieBLoc.listMovieSql;
    } else {
      movieBLoc.fetchMovie();
      //stream = movieBLoc.listMovie;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies DB'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.deepPurple,
        child: StreamBuilder<List<Result>>(
            stream: movieBLoc.listMovie,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for (var snapshots in snapshot.data) {
                  saveDB(snapshots);
                }
                return buildList(snapshot);
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ));
              }
            }),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<List<Result>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
          child: Material(
            type: MaterialType.card,
            elevation: 0.5,
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(0, -20, 0, 0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailMovie(data: snapshot.data[index]),
                  ),
                );
              },
              title: Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: FadeInImage.assetNetwork(
                        alignment: Alignment.topCenter, // add this
                        placeholder: 'http://image.tmdb.org/t/p/w185/' +
                            snapshot.data[index].posterPath,
                        image: 'http://image.tmdb.org/t/p/w185/' +
                            snapshot.data[index].posterPath,
                        fit: BoxFit.fitHeight,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Text(
                        snapshot.data[index].title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 0, 20),
                          child: Icon(
                            Icons.thumb_up,
                            size: 12,
                            color: Colors.purple,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 20, 20),
                          child: Text(
                            snapshot.data[index].voteCount.toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future saveDB(Result data) async {
    var db = DBHelper();
    var movies = Result(
      posterPath: data.posterPath,
      backdropPath: data.backdropPath,
      title: data.title,
      voteCount: data.voteCount,
      overview: data.overview,
    );
    print(movies.title);
    var result;

    result = await db.addMovies(movies);

    print('berhasil insert db local' + result.toString());
  }
}
