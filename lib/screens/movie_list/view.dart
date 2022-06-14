import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/movies_cubit.dart';
import '../../cubits/movies_states.dart';
import '../../models/category.dart';
import '../movie_details/view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: BlocProvider(
        create: (context) => HomeCubit()..getCategories(),
        child: BlocBuilder<HomeCubit, HomeStates>(
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is HomeSuccessState) {
              final movies = state.movies;
              final categories = state.categories;
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: CategoriesDropMenu(
                      items: categories,
                      onChanged: (value) {
                        context.read<HomeCubit>().getMoviesByCategory(true);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsScreen(
                                movie: movies[index],
                              ),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                height: 330,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: Colors.grey.withOpacity(.9),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(28)),
                                      child: Image.network(
                                        movies[index].image,
                                        width: double.infinity,
                                        height: 300,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      margin: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black.withOpacity(.8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star_half_outlined,
                                            color: Colors.yellow,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            movies[index].rate,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 10),
                                        child: Text(
                                          movies[index].title,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: ElevatedButton(
                  onPressed: context.read<HomeCubit>().getCategories,
                  child: const Text('Error, Try again!'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CategoriesDropMenu extends StatefulWidget {
  const CategoriesDropMenu(
      {Key? key, required this.onChanged, required this.items})
      : super(key: key);
  final List<Category> items;
  final Function(Category) onChanged;

  @override
  State<CategoriesDropMenu> createState() => _CategoriesDropMenuState();
}

class _CategoriesDropMenuState extends State<CategoriesDropMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Category>(
      value: context.read<HomeCubit>().selectedCategory,
      items: widget.items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.name),
              ))
          .toList(),
      onChanged: (value) {
        context.read<HomeCubit>().selectedCategory = value!;
        widget.onChanged(value);
        setState(() {});
      },
    );
  }
}
