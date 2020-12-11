import 'package:omdb_dart/model/movie.dart';
import 'package:omdb_dart/omdb_dart.dart';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

class MyOmdb extends Omdb {
  MyOmdb(this._api, this._movieName, [this._year]) : super(_api, _movieName);

  @override
  final String base_url = 'http://www.omdbapi.com/';

  @override
  late Movie movie;

  String _api;
  String _movieName;
  int? _year;

  @override
  Future<void> getMovie() async {
    String myurl = '$base_url?t=$_movieName&apikey=$_api&type=movie';
    if (_year != null) myurl += '&y=$_year';
    print(myurl);
    var res = await http.get(myurl);
    var decodedjson = jsonDecode(res.body);
    movie = Movie.fromJson(decodedjson);
  }
}
