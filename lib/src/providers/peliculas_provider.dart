

import 'dart:async';

import 'package:pelicula_app/src/models/actores_model.dart';
import 'package:pelicula_app/src/models/pelicula_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; 
// import 'package:peliculas/src/models/actores_model.dart';
class PeliculasProvider{
  String _apikey  ='d2dea6fffc391cc87d476cf63fee712c';
  String _url     ='api.themoviedb.org';
  String _language='es-Es';
  int _popularesPage = 0;

  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamContoller = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamContoller.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamContoller.stream;

  void disposeStreams(){
    _popularesStreamContoller?.close();
  }




  Future<List<Pelicula>>_procesarPelicula(Uri url)async{
    final resp = await http.get( url );
    final decodeData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;

  }
  

  Future<List<Pelicula>>getEnCines()async{
    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key'   : _apikey,
      'language'  : _language
    });

    return await _procesarPelicula(url);


  }



  Future<List<Pelicula>>getPopulares()async{
    _popularesPage ++;

    if(_cargando) return [];

    _cargando = true;

    final url = Uri.https(_url, '3/movie/popular',{
      'api_key'   : _apikey,
      'language'  : _language,
      'page'      : _popularesPage.toString()
    });

    final resp = await _procesarPelicula(url);
    
    _populares.addAll(resp);
    popularesSink(_populares);
    
    _cargando =false;
    return resp;

  }

  Future<List<Actor>> getCast(String peliId)async{
    final url = Uri.https(_url, '3/movie/$peliId/credits',
    {
      'api_key'   : _apikey,
      'language'  : _language,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);
    
    return cast.actores;
  }
  Future<List<Pelicula>>buscarPelicula( String query )async{
    final url = Uri.https(_url, '3/search/movie',{
      'api_key'   : _apikey,
      'language'  : _language,
      'query'     : query
    });

    return await _procesarPelicula(url);


  }

}