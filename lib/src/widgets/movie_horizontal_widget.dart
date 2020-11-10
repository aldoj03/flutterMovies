import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;


  final _pageController = PageController(
    viewportFraction: 0.3,
    initialPage: 1,
  );

  final Function siguientePagina;

  MovieHorizontal(
      {Key key, @required this.peliculas, @required this.siguientePagina});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    

    _pageController.addListener(() {
      if (_pageController.position.pixels + 200 >=
          _pageController.position.maxScrollExtent) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.3,
      margin: EdgeInsets.only(top: 30.0),
      child: PageView.builder(
        pageSnapping: false,
        // children: _tarjetas(),
        itemBuilder: (BuildContext context, index) =>
            _tarjeta(context, peliculas[index]),
        itemCount: peliculas.length,
        controller: _pageController,
      ),
    );
  }

  
  Widget _tarjeta(BuildContext context, Pelicula pelicula) {

    pelicula.uniqueId = '${pelicula.id}-poster';
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPoster()),
                placeholder: AssetImage('lib/src/assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            pelicula.title,
            style: Theme.of(context).textTheme.caption,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );

    return GestureDetector(
        child: tarjeta,
        onTap: () =>
            {Navigator.pushNamed(context, 'detalle', arguments: pelicula)});
  }
}
