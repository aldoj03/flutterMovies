import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actor_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(slivers: [
      _crearAppbar(pelicula),
      SliverList(
          delegate: SliverChildListDelegate([
        SizedBox(
          height: 20.0,
        ),
        _posterTitulo(pelicula, context),
        _descripcion(pelicula),
        _cast(pelicula)
      ]))
    ]));
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(pelicula.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12.0, shadows: [
              Shadow(
                  color: Colors.black, blurRadius: 20.0, offset: Offset(3, 4))
            ])),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgorund()),
          placeholder: AssetImage('lib/src/assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          alignment: Alignment.topCenter,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula, BuildContext context) {
        return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: NetworkImage(pelicula.getPoster()),
                  height: 150.0,
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pelicula.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  pelicula.originalTitle,
                  style: Theme.of(context).textTheme.caption,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
                Row(children: [
                  Icon(Icons.star_border),
                  Text(pelicula.voteAverage.toString())
                ])
              ],
            ))
          ],
        ));
  }

  Widget _descripcion(pelicula) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Text(pelicula.overview, textAlign: TextAlign.justify));
  }

  Widget _cast(Pelicula pelicula) {
    final peliProvider = PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getActores(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _actorePageView(snapshot.data, context);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _actorePageView(List<Actor> actores, context) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        itemBuilder: (context, index) => _actorTarjeta(actores[index], context),
        itemCount: actores.length,
        controller: PageController(
          initialPage: 1,
          viewportFraction: 0.3,
        ),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor, context) {
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: FadeInImage(
              image: NetworkImage(actor.getPoster()),
              placeholder: AssetImage('lib/src/assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.0),
          Text(actor.name,
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}
