import 'package:flutter/material.dart';

import 'screens/recipesList.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "RecipeApp",
      home: RecipesListScreen() 
    );

  }

}