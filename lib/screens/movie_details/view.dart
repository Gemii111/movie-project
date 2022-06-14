import 'package:flutter/material.dart';
import '../../models/movie.dart';
class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Column(
        children: [SizedBox(height: 10,),
          Expanded(child: Image.network(movie.image,)),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(movie.description,),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
