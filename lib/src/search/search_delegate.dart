import 'package:flutter/material.dart';
import 'package:pelicula_app/src/models/pelicula_model.dart';
import 'package:pelicula_app/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{
  
  String seleccion ='';
  final peliculasProvider = new PeliculasProvider();
  final peliculas = [
    'Coco 3D',
    'agarra Nalga'
  ];
  final peliculasRecientes =[
    'Spiderman',
    'Capitan America'
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon:Icon( Icons.close ) , 
        onPressed: (){
          query = '';
        })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        ),
      onPressed: (){
        close( context, null );
      });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        
      ),

    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    // Son las sugerencias cuando la persona escribe
    if(query.isEmpty){
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),  
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        
        if( snapshot.hasData ){
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map(  ( pelicula  ) {
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'), 
                  image: NetworkImage(  pelicula.getPosterImg() ),
                  width: 50.0,
                  fit: BoxFit.contain,
                  ),
                  title: Text( pelicula.title ),
                  subtitle: Text( pelicula.originalTitle ),

                  onTap: (){
                    close( context, null);
                    pelicula.uniqueId= '';
                    Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                  },
              );
            }).toList()
          ); 
        
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
    
    
    
    
    
    
    

    // final listaSugerida = (query.isEmpty) 
    //                         ? peliculasRecientes
    //                         : peliculas.where((p)=>p.toLowerCase().startsWith((query.toLowerCase())) 
    //                         ).toList();

    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (context, i){
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugerida[i]),
    //       onTap: (){

    //       },
    //     );
    //   },
    // );
  }

  

}