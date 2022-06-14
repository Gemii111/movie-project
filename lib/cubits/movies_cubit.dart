import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/category.dart';
import '../models/movie.dart';
import 'movies_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeLoadingState());

  final Dio _dio = Dio();

  Category? selectedCategory;

  Future<void> getCategories() async {
    final result = await _dio.get('https://api.themoviedb.org/3/genre/movie/list?api_key=2001486a0f63e9e4ef9c4da157ef37cd');
    final categories = (result.data['genres'] as List).map((e) => Category.fromJson(e)).toList();
    selectedCategory = categories.first;
    final movies = await getMoviesByCategory();
    emit(HomeSuccessState(
      movies: movies,
      categories: categories
    ));
  }

  Future<List<Movie>> getMoviesByCategory([bool emitLoading = false]) async {
    try {
      List<Category> categories = [];
      if (state is HomeSuccessState) {
        categories = (state as HomeSuccessState).categories;
      }
      if (emitLoading) {
        emit(HomeLoadingState());
      }
      final result = await _dio.get('https://api.themoviedb.org/3/discover/movie?with_genres=${selectedCategory!.id}&api_key=2001486a0f63e9e4ef9c4da157ef37cd');
      final movies = (result.data['results'] as List).map((e) => Movie.fromJson(e)).toList();
      if (emitLoading) {
        emit(HomeSuccessState(movies: movies, categories: categories));
      }
      return movies;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

}