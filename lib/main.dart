import 'MyOmdb.dart';
import 'api_key.dart';

void main() async {
  try {
    MyOmdb client = MyOmdb(Keys.OMDB_KEY, 'Suspiria', 2018);
    await client.getMovie();
    print('Title : ${client.movie.title}');
    print('Released : ${client.movie.released}');
    print('Runtime : ${client.movie.runtime}');
    print('Poster URL : ${client.movie.poster}'); //URL of poster
    print('Director :${client.movie.director} ');
    print('Writer :${client.movie.writer} ');
    print('Actors :${client.movie.actors} ');
    print('Plot :${client.movie.plot} ');
    print('Language :${client.movie.language} ');
    print('Country :${client.movie.country} ');
    print('Awards :${client.movie.awards} ');
    print('Meta Score :${client.movie.metascore} ');
    print('IMDB Rating :${client.movie.imdbRating} ');
    print('IMDB Votes :${client.movie.imdbVotes} ');
    print('IMDB ID :${client.movie.imdbID} ');
    print('Website :${client.movie.website} ');
    print('Production :${client.movie.production} ');
    print('Box Office :${client.movie.boxOffice} ');
  } catch (e) {
    print(e);
  }
}
