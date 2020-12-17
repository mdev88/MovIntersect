import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:omdb_dart/model/movie.dart';
import 'package:omdb_dart/omdb_dart.dart';

class MyOmdb extends Omdb {
  MyOmdb(this._api, this._movieName, [this._year]) : super(_api, _movieName);

  @override
  final String base_url = 'http://www.omdbapi.com/';

  late Movie movie;

  final String _api;
  final String _movieName;
  final int? _year;

  Future<void> getMovie() async {
    String myurl = '$base_url?t=$_movieName&apikey=$_api&type=movie';
    if (_year != null) myurl += '&y=$_year';
    var res = await http.get(myurl);
    var decodedjson = jsonDecode(res.body);
    movie = Movie.fromJson(decodedjson);
  }
}