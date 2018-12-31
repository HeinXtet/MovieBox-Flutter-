import 'package:flutter/material.dart';
import 'package:movie_box/main/movie.dart';
import 'package:movie_box/main/series.dart';

const String base_url = "https://api.themoviedb.org/3";
const String API_KEY = "961277648f1e28c74788bade62b3b24c";
const String poster_base_url = "http://image.tmdb.org/t/p/w500/";
const String top_rated_movie = "$base_url/movie/top_rated?api_key=961277648f1e28c74788bade62b3b24c&language=en-US&page=1";
const String now_playing_movie = "$base_url/movie/now_playing?api_key=961277648f1e28c74788bade62b3b24c&language=en-US&page=1";

const main_bottom_menu = [
  BottomNavigationBarItem(
      icon: Icon(Icons.movie),
      title: Text("Movie")),
  BottomNavigationBarItem(
      icon: Icon(Icons.insert_invitation),
      title: Text("Series")
  )
];

List<Widget> bottom_nav_widget = [
  Movie(),
  Series()
];