import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'recipeEdit.dart';
import 'recipesList.dart';

import '../storage/recipeStore.dart';

class RecipeViewScreen extends StatelessWidget {

  final Recipe recipe;

  RecipeViewScreen({
    required this.recipe
  });

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => close(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => openEditor(context),
            ),
          )
        ],
      ),

      body: Markdown(data: getRawMarkdown()),
    );
  }

  String getRawMarkdown() {
    String markdown = "";

    markdown += "# ${recipe.title}\n"; // add title
    markdown += "${recipe.description}\n"; // add description
    markdown += "## Ingredients \n"; // add ingredients header

    for (var ingredient in recipe.ingredients) {
      // add each ingredient as a dot point
      markdown += "- $ingredient\n";
    }

    markdown += "## Instructions \n"; // add steps header

    for (var i = 0; i < recipe.steps.length; i++) {
      // add each step as a numbered point
      markdown += "${i+1}. ${recipe.steps[i]}\n";
    }

    return markdown;
  }

  void close(BuildContext context) {
    Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => RecipesListScreen())
    );
  }

  void openEditor(BuildContext context) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => RecipeEditScreen(
        recipeTitle: recipe.title,
        editMode: true,
        fromListScreen: false,
      ))
    );
  }

}