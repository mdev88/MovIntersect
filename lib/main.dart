import 'dart:io';

import 'MyOmdb.dart';
import 'api_key.dart';

void main() async {
  late MyOmdb movie1;
  late MyOmdb movie2;

  try {
    // Get movie 1
    String confirm = 'n';
    while (confirm != 'y' || confirm == '') {
      if (confirm == 'q') exit(1);
      movie1 = await queryMovie();

      stdout.write('Is this the movie you were looking for? [Y/n/q]: ');
      confirm = stdin.readLineSync()!.toLowerCase();
    }

    // Get movie 2
    confirm = 'n';
    while (confirm != 'y' || confirm == '') {
      if (confirm == 'q') exit(1);
      movie2 = await queryMovie();

      stdout.write('Is this the movie you were looking for? [Y/n/q]: ');
      confirm = stdin.readLineSync()!.toLowerCase();
    }

    // Same movie?
    if (movie1.movie.imdbID == movie2.movie.imdbID) {
      print('They are both the same movie!');
      exit(0);
    }

    // Director
    if (movie1.movie.director.contains(movie2.movie.director)) {
      print('Both movies were directed by ${movie2.movie.director}');
    } else if (movie2.movie.director.contains(movie1.movie.director)) {
      print('Both movies were directed by ${movie1.movie.director}');
    }

    // Writer
    if (movie1.movie.writer.contains(movie2.movie.writer)) {
      print('Both movies were written by ${movie2.movie.writer}');
    } else if (movie2.movie.writer.contains(movie1.movie.writer)) {
      print('Both movies were written by ${movie1.movie.writer}');
    }

    // print('Runtime: ${movie1.movie.runtime}');
    // print('Poster URL: ${movie1.movie.poster}'); //URL of poster
    // print('Director:${movie1.movie.director} ');
    // print('Writer:${movie1.movie.writer} ');
    // print('Actors:${movie1.movie.actors} ');
    // print('Language:${movie1.movie.language} ');
    // print('Country:${movie1.movie.country} ');
    // print('Awards:${movie1.movie.awards} ');
    // print('Meta Score:${movie1.movie.metascore} ');
    // print('IMDB Rating:${movie1.movie.imdbRating} ');
    // print('IMDB Votes:${movie1.movie.imdbVotes} ');
    // print('IMDB ID:${movie1.movie.imdbID} ');
    // print('Website:${movie1.movie.website} ');
    // print('Production:${movie1.movie.production} ');
    // print('Box Office:${movie1.movie.boxOffice} ');
  } catch (e) {
    print(e);
  }
}

Future<MyOmdb> queryMovie() async {
  stdout.write('Enter movie title: ');
  String movie1 = stdin.readLineSync()!;

  stdout.write('(Optional) Enter year of release [ENTER to skip]): ');
  int? year1 = int.tryParse(stdin.readLineSync()!);

  MyOmdb client = MyOmdb(Keys.OMDB_KEY, movie1, year1);
  await client.getMovie();

  print('');
  print('Title: ${client.movie.title}');
  print('Released: ${client.movie.released}');
  print('Plot:${client.movie.plot} ');
  print('');

  print(client.movie.toJson());

  return client;
}
