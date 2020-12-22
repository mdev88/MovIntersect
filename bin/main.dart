import 'dart:io';

import 'package:omdb_dart/model/movie.dart';

import '../lib/entities/my_omdb.dart';

void main() async {
  late Movie movie1;
  late Movie movie2;

  try {
    // Get movie 1
    String? confirm = 'n';
    while (confirm != 'y') {
      if (confirm == 'q') exit(1);
      if (confirm == '') break;
      try {
        movie1 = await queryMovie();
        stdout.write('Is this the movie you were looking for? [Y/n/q]: ');
        confirm = stdin.readLineSync()?.toLowerCase();
      } catch (e) {
        print('\nMovie not found, please try again');
      }
    }

    // Get movie 2
    confirm = 'n';
    while (confirm != 'y') {
      if (confirm == 'q') exit(1);
      if (confirm == '') break;
      try {
        movie2 = await queryMovie();
        stdout.write('Is this the movie you were looking for? [Y/n/q]: ');
        confirm = stdin.readLineSync()?.toLowerCase();
      } catch (e) {
        print('\nMovie not found, please try again');
      }
    }

    print('\n####################');
    print('MOVINTERSECT RESULTS');
    print('####################');

    // Same movie?
    if (movie1.imdbID == movie2.imdbID) {
      print('They are the same movie!');
      exit(0);
    }

    // Director/s
    movie1.directorsList
        .removeWhere((element) => !movie2.directorsList.contains(element));
    if (movie1.directorsList.isNotEmpty) {
      print(
          '> Both movies were directed by ${movie1.directorsList.join(', ')}');
    }

    // Writer/s
    movie1.writersList
        .removeWhere((element) => !movie2.writersList.contains(element));
    if (movie1.writersList.isNotEmpty) {
      print('> Both movies were written by ${movie1.writersList.join(', ')}');
    }

    // Actor/s
    movie1.actorsList
        .removeWhere((element) => !movie2.actorsList.contains(element));
    if (movie1.actorsList.isNotEmpty) {
      print(
          '> Actor/s or Acress/es in common: ${movie1.actorsList.join(', ')}');
    }

    // Country
    movie1.countryList
        .removeWhere((element) => !movie2.countryList.contains(element));
    if (movie1.countryList.isNotEmpty) {
      print('> Both movies are from: ${movie1.countryList.join(', ')}');
    }

    // Language
    movie1.langList
        .removeWhere((element) => !movie2.langList.contains(element));
    if (movie1.langList.isNotEmpty) {
      print('> Language/s in common: ${movie1.langList.join(', ')}');
    }

    // Runtime
    if (movie1.runtime == movie2.runtime) {
      print('> Both movies have the exact same runtime!: ${movie1.runtime}');
    }

    print('\n');
  } catch (e) {
    print(e);
  }
}

// Asks for user input and returns result from API
Future<Movie> queryMovie() async {
  String movie = '';
  while (movie.isEmpty) {
    if (movie == 'q') exit(0);
    stdout.write('\nEnter movie title [q to exit]: ');
    movie = stdin.readLineSync()!;
  }

  stdout.write('(Optional) Enter year of release [ENTER to skip]): ');
  int? year = int.tryParse(stdin.readLineSync()!); // TODO validate input

  MyOmdb client = MyOmdb(movie, year);
  await client.getMovie();

  if (client.movie.title == null) throw Exception('Movie not found');

  print('\n*****');
  print('Title: ${client.movie.title} (${client.movie.year})');
  print('Plot:${client.movie.plot} ');
  print('*****\n');

  return client.movie;
}

// Parses a comma separated list of names in a String to a List object
List<String> stringFieldToList(String input) {
  List<String> txt = input.split(',');
  for (int i = 0; i < txt.length; i++) {
    if (txt[i].contains('(')) {
      txt[i] =
          txt[i].replaceRange(txt[i].indexOf('('), txt[i].indexOf(')') + 1, '');
    }
    txt[i] = txt[i].trim();
  }
  return txt;
}

/*
 * Extension functions
 */

/// Returns the director/s in the form of a List
extension on Movie {
  List<String> get directorsList {
    return stringFieldToList(director);
  }
}

/// Returns the writer/s in the form of a List
extension on Movie {
  List<String> get writersList {
    return stringFieldToList(writer);
  }
}

/// Returns the actor/s/actress/es in the form of a List
extension on Movie {
  List<String> get actorsList {
    return stringFieldToList(actors);
  }
}

/// Returns the producing companies in the form of a List
extension on Movie {
  List<String> get prodList {
    return stringFieldToList(production);
  }
}

/// Returns the country/ies of origin in the form of a List
extension on Movie {
  List<String> get countryList {
    return stringFieldToList(country);
  }
}

/// Returns the languages in the form of a List
extension on Movie {
  List<String> get langList {
    return stringFieldToList(language);
  }
}
