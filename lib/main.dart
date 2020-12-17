import 'dart:io';

import 'package:omdb_dart/model/movie.dart';

import 'entities/my_omdb.dart';
import 'api_key.dart';

void main() async {
  late MyOmdb movie1;
  late MyOmdb movie2;

  try {
    // Get movie 1
    String? confirm = 'n';
    while (confirm != 'y') {
      if (confirm == 'q') exit(1);
      if (confirm == '') break;
      movie1 = await queryMovie();

      stdout.write('Is this the movie you were looking for? [Y/n/q]: ');
      confirm = stdin.readLineSync()?.toLowerCase();
    }

    // Get movie 2
    confirm = 'n';
    while (confirm != 'y') {
      if (confirm == 'q') exit(1);
      if (confirm == '') break;
      movie2 = await queryMovie();

      stdout.write('Is this the movie you were looking for? [Y/n/q]: ');
      confirm = stdin.readLineSync()?.toLowerCase();
    }

    // Same movie?
    if (movie1.movie.imdbID == movie2.movie.imdbID) {
      print('They are the same movie!');
      exit(0);
    }

    // Director/s
    List<String> directorsMatch = [];
    for (String director in movie1.movie.directorsList) {
      if (movie2.movie.directorsList.contains(director)) {
        directorsMatch.add(director);
      }
    }
    if (directorsMatch.isNotEmpty) {
      print('Both were directed by ${directorsMatch.join(', ')}');
    }

    // Writer/s
    List<String> writersMatch = [];
    for (String writer in movie1.movie.writersList) {
      if (movie2.movie.writersList.contains(writer)) {
        writersMatch.add(writer);
      }
    }
    if (writersMatch.isNotEmpty) {
      print('Both were written by ${writersMatch.join(', ')}');
    }

    // Actor/s
    List<String> actorsMatch = [];
    for (String actor in movie1.movie.actorsList) {
      if (movie2.movie.actorsList.contains(actor)) {
        actorsMatch.add(actor);
      }
    }
    if (actorsMatch.isNotEmpty) {
      print('Shared actor/s/actress/es : ${actorsMatch.join(', ')}');
    }

    // print('Director:${movie1.movie.director} ');
    // print('Writer:${movie1.movie.writer} ');
    // print('Runtime: ${movie1.movie.runtime}');
    // print('Poster URL: ${movie1.movie.poster}'); //URL of poster
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
  String movie = '';
  while (movie.isEmpty) {
    if (movie == 'q') exit(0);
    stdout.write('Enter movie title [q to exit]: ');
    movie = stdin.readLineSync()!;
  }

  stdout.write('(Optional) Enter year of release [ENTER to skip]): ');
  int? year = int.tryParse(stdin.readLineSync()!); // TODO validate input

  MyOmdb client = MyOmdb(Keys.OMDB_KEY, movie, year);
  await client.getMovie();

  print('\n*****');
  print('Title: ${client.movie.title} (${client.movie.year})');
  print('Plot:${client.movie.plot} ');
  // print('Director/s:${client.movie.directorsList} ');
  // print('Writer/s:${client.movie.writersList} ');
  print('Actor/s:${client.movie.actorsList} ');
  print('*****\n');

  return client;
}

/// Returns the director/s in the form of a List<String>
extension on Movie {
  List<String> get directorsList {
    List<String> directors = director.split(',');
    for (int i = 0; i < directors.length; i++) {
      if (directors[i].contains('(')) {
        directors[i] = directors[i].replaceRange(
            directors[i].indexOf('('), directors[i].indexOf(')') + 1, '');
      }
      directors[i] = directors[i].trim();
    }
    return directors;
  }
}

/// Returns the writer/s in the form of a List<String>
extension on Movie {
  List<String> get writersList {
    List<String> writers = writer.split(',');
    for (int i = 0; i < writers.length; i++) {
      if (writers[i].contains('(')) {
        writers[i] = writers[i].replaceRange(
            writers[i].indexOf('('), writers[i].indexOf(')') + 1, '');
      }
      writers[i] = writers[i].trim();
    }
    return writers;
  }
}

/// Returns the actor/s/actress/es in the form of a List<String>
extension on Movie {
  List<String> get actorsList {
    List<String> act = actors.split(',');
    for (int i = 0; i < act.length; i++) {
      if (act[i].contains('(')) {
        act[i] = act[i]
            .replaceRange(act[i].indexOf('('), act[i].indexOf(')') + 1, '');
      }
      act[i] = act[i].trim();
    }
    return act;
  }
}
