import 'package:flutter/material.dart';

import 'recipeEdit.dart';
import '../storage/recipeStore.dart';

class RecipeViewScreen extends StatelessWidget {

  final String title;

  RecipeViewScreen({
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    final db = RecipeStore();

    return Scaffold(
      appBar: AppBar(
        title: Text("View"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          )
        ],
      ),
    );

  }

}