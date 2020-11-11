import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actor_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {

  String _apiKey = '62d6add13adfb63f1f8e90fa27b481ad';
  String _url = 'api.themoviedb.org';
  String _language = 'es-Es';

  int _popularesPage = 0;

  bool cargandoDatos = false;

  List<Pelicula> _populares = List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();


  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;




  Future<List<Pelicula>> getCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});
   return await _makePeticion(url);
  }

   Future<List<Pelicula>> getCinesSearch(query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});
   return await _makePeticion(url);
  }



  Future<List<Pelicula>> getPopulares() async {

    if(cargandoDatos) return [];

    cargandoDatos = true;


    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });
    final res = await _makePeticion(url);

    _populares.addAll(res);

    popularesSink(_populares);

    cargandoDatos = false;
  
    return res;
  }

  Future<List<Actor>> getActores( String id ) async {

     final url = Uri.https(_url, '3/movie/$id/credits', {
      'api_key': _apiKey,
      'language': _language,
    });


    final resp = await http.get(url);
 
    
      final decodedData = json.decode(resp.body);

      final cast = Actores.fromJsonList(decodedData['cast']);

      return cast.actores;

  }

  Future<List<Pelicula>> _makePeticion(Uri url) async {
      final resp = await http.get(url);

      final decodedData = json.decode(resp.body);

      final peliculas = Peliculas.fromJsonList(decodedData['results']).items;
    return peliculas;

  }
}
