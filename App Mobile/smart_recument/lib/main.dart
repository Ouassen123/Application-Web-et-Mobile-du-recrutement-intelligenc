import 'package:flutter/material.dart';
import 'package:smart_recument/screens/welcome.dart';
import 'package:smart_recument/screens/home_screen.dart';
import 'package:smart_recument/screens/not_found_screen.dart';
import 'package:smart_recument/screens/signup_screen.dart';
import 'package:smart_recument/screens/post_job_screen.dart';
import 'package:smart_recument/screens/contact_screen.dart';
import 'favorites_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recrutement',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF89BA16, {
          50: Color(0xFFE8F5D8),
          100: Color(0xFFC6E39E),
          200: Color(0xFF9ED464),
          300: Color(0xFF77BD2A),
          400: Color(0xFF5CA40B),
          500: Color(0xFF428A00),
          600: Color(0xFF3B8000),
          700: Color(0xFF327300),
          800: Color(0xFF2A6700),
          900: Color(0xFF1C4D00),
        }),
      ),
      home: WelcomeScreen(), // Affiche la page WelcomeScreen en premier
      // Define your routes here
      routes: {
        '/signup': (context) => SignupScreen(),
        '/home': (context) => FavoritesProvider(
              // Utilisez le provider ici
              favoriteJobListings: [], // Initialisez cette liste avec les favoris
              addToFavorites: (jobListing) {
                // Ajoutez la logique pour ajouter un favori ici
              },
              removeFromFavorites: (jobListing) {
                // Ajoutez la logique pour supprimer un favori ici
              },
              child: HomeScreen(
                arguments: ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>,
              ),
            ),

        '/postjob': (context) => PostJobScreen(),
        '/contact': (context) => ContactScreen(),
        // Add more routes if needed
      },
      // Define the default route (if the user tries to access an undefined route)
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => NotFoundScreen());
      },
    );
  }
}
