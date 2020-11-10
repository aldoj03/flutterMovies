import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  List<Pelicula> peliculas;
  CardSwiper({Key key, @required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screensize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

          return GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, 'detalle',
                  arguments: this.peliculas[index])
            },
            child: Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    image: NetworkImage(
                      this.peliculas[index].getPoster(),
                    ),
                    placeholder: AssetImage('lib/src/assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )),
            ),
          );
        },
        itemWidth: _screensize.width * 0.7,
        itemHeight: _screensize.height * 0.45,
        itemCount: peliculas.length,
        layout: SwiperLayout.STACK,
        // pagination:  SwiperPagination(),
        // control:  SwiperControl()
      ),
    );
  }
}
