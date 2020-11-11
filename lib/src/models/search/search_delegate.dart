
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final peliculasProvider = PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del appbar (limpiar o cancelar busqueda)

    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar

    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //   final listaSugerida = (query.isEmpty)
    //       ? peliculasRecientes
    //       : peliculas
    //           .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
    //           .toList();

    //   // Sugerencias que aparecen cuando se escribe
    //   return ListView.builder(
    //     itemCount: listaSugerida.length,
    //     itemBuilder: (context, index) {
    //       return ListTile(
    //         leading: Icon(Icons.movie),
    //         title: Text(listaSugerida[index]),
    //         onTap: () {},
    //       );
    //     },
    //   );
    // }

    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: peliculasProvider.getCinesSearch(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final peliculas = snapshot.data;

        return ListView.builder(
          itemCount: peliculas.length,
          itemBuilder: (context, i) {
            peliculas[i].uniqueId = '${peliculas[i].id}-search';
            return ListTile(
                leading: Hero(
                  tag: peliculas[i].uniqueId,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FadeInImage(
                      image: NetworkImage(peliculas[i].getPoster()),
                      placeholder:
                          AssetImage('lib/src/assets/img/no-image.jpg'),
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(peliculas[i].title),
                subtitle: Text(peliculas[i].originalTitle),
                onTap: () => Navigator.pushNamed(context, 'detalle',
                    arguments: peliculas[i]));
          },
        );
      },
    );
  }
}
