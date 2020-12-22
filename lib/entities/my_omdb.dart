import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:omdb_dart/model/movie.dart';
import 'package:omdb_dart/omdb_dart.dart';

import '../api_key.dart';

class MyOmdb extends Omdb {
  MyOmdb(this._movieName, [this._year]) : super(Keys.OMDB_KEY, _movieName);

  @override
  final String base_url = 'http://www.omdbapi.com/';

  final String _movieName;
  final int? _year;

  @override
  Future<void> getMovie() async {
    String myurl = '$base_url?t=$_movieName&apikey=${Keys.OMDB_KEY}&type=movie';
    if (_year != null) myurl += '&y=$_year';
    var res = await http.get(myurl);
    var decodedjson = jsonDecode(res.body);
    movie = Movie.fromJson(decodedjson);
  }
}
