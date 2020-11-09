import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;

  MovieHorizontal({Key key, @required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      height: _screenSize.height * 0.3 ,
      margin: EdgeInsets.only(top: 30.0),
      child: PageView(
        pageSnapping: false,
        children: _tarjetas(),
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
      ),
    );
  }

  List<Widget> _tarjetas() {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 20.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPoster()),
                placeholder: AssetImage('lib/src/assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            )
          ],
        ),
      );
    }).toList();
  }
}
