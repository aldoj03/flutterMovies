import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apiKey = '62d6add13adfb63f1f8e90fa27b481ad';
  String _url = 'api.themoviedb.org';
  String _language = 'es-Es';

  int _popularesPage = 0;

  List<Pelicula> _populares = List();

  final _popularesStream = StreamController();

  Future<List<Pelicula>> getCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});
   return await _makePeticion(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });
   return await _makePeticion(url);
  }

  Future<List<Pelicula>> _makePeticion(Uri url) async {
      final resp = await http.get(url);

      final decodedData = json.decode(resp.body);

      final peliculas = Peliculas.fromJsonList(decodedData['results']).items;
    return peliculas;

  }
}
