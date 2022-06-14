import '../models/category.dart';
import '../models/movie.dart';
abstract class HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeSuccessState extends HomeStates {
  final List<Category> categories;
  final List<Movie> movies;
  HomeSuccessState({required this.movies, required this.categories});
}

class HomeErrorState extends HomeStates {}