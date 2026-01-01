import 'dart:convert';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/review.dart';
import 'package:movies/models/person.dart';

class ApiService {
  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].skip(6).take(5).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      http.Response response =
          await http.get(Uri.parse('${Api.baseUrl}movie/$url'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=YourApiKey&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']),
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }

  static Future<Person?> getPersonId(String id) async {
    Person people;
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/$id?api_key=${Api.apiKey}&language=en-US&page=1'));
      people = Person.fromJson(response.body);
      return people;
    } catch (e) {
      return null;
    }
  }

  static Future<Person> getPersonDetails(String id) async {
    final response = await http
        .get(Uri.parse('${Api.baseUrl}person/$id?api_key=${Api.apiKey}'));

    if (response.statusCode == 200) {
      return Person.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fallo al cargar los datos');
    }
  }

  static Future<List<Movie>?> getMoviePerson(String id) async {
    List<Movie> mv = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/$id/movie_credits?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['cast'].forEach(
        (m) {
          mv.add(Movie.fromMap(m));
        },
      );
      return mv;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Person>?> getSearch(String query) async {
    List<Person> persons = [];
    List<Person> infoActors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/person?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => persons.add(
          Person.fromMap(m),
        ),
      );
      // Para cada actor encontrado, obtiene información detallada usando actorById.
      for (var actor in persons) {
        try {
          Person? infoActor = await getPersonId(actor.id.toString());
          infoActors.add(infoActor!);
        } catch (e) {
          return null;
        }
      }
      return infoActors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Person>?> topPersons() async {
    List<Person> person = [];
    List<Person> detailedList = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/popular?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);

      res['results'].take(10).forEach(
            (a) => person.add(
              Person.fromMap(a),
            ),
          );

      for (var a in person) {
        Person? det = await getPersonId(a.id.toString());
        if (det != null) {
          detailedList.add((det));
        }
      }
      return detailedList;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Person>?> trendingActors() async {
    List<Person> person = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}trending/person/day?api_key=${Api.apiKey}&language=en-US&page=10'));
      var res = jsonDecode(response.body);
      res['results'].skip(10).take(9).forEach(
            (a) => person.add(
              Person.fromMap(a),
            ),
          );
      return person;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Person>?> popularActors() async {
    List<Person> person = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/popular?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].skip(10).take(9).forEach(
            (a) => person.add(
              Person.fromMap(a),
            ),
          );
      List<Person> infoActors = [];
      for (var actor in person) {
        try {
          Person? actorInfo = await getPersonId(actor.id.toString());
          infoActors.add(actorInfo!);
        } catch (e) {
          return null;
        }
      }
      return infoActors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Person>?> getMovieCast(int movieId) async {
    List<Person> castList = [];
    try {
      String url =
          '${Api.baseUrl}movie/$movieId/credits?api_key=${Api.apiKey}&language=en-US';

      http.Response response = await http.get(Uri.parse(url));
      var res = jsonDecode(response.body);

      if (res['cast'] != null) {
        res['cast'].take(10).forEach((c) {
          castList.add(Person.fromMap(c));
        });
      }
      return castList;
    } catch (e) {
      return null;
    }
  }
}
