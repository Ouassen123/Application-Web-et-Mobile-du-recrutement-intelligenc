import 'package:flutter/material.dart';
import 'package:smart_recument/screens/home_screen.dart';

class FavoritesProvider extends InheritedWidget {
  final List<JobListing> favoriteJobListings;
  final Function(JobListing) addToFavorites;
  final Function(JobListing) removeFromFavorites;

  FavoritesProvider({
    required this.favoriteJobListings,
    required this.addToFavorites,
    required this.removeFromFavorites,
    required Widget child,
  }) : super(child: child);

  static FavoritesProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FavoritesProvider>();
  }

  @override
  bool updateShouldNotify(FavoritesProvider oldWidget) {
    return favoriteJobListings != oldWidget.favoriteJobListings;
  }
}
