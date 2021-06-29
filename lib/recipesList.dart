import 'package:flutter/material.dart';

import './recipeItem.dart';

class RecipesListScreen extends StatefulWidget {
  @override
  _RecipesListScreenState createState() => _RecipesListScreenState();

}

class _RecipesListScreenState extends State<RecipesListScreen> {

  //TEST list of recipe names
  List<String> _recipeNames = ["Chili con Carne", "Cinnamon Rolls", 
    "Salted Caramel Fudge", "Pulled Pork", "Gumbo"];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      //top bar of screen
      appBar: AppBar(
        title: Text("Recipe Manager")
      ),

      body: ListView(
        // create list of widgets from list of recipe names
        children: _recipeNames.map(
          (name) => 
            GestureDetector(
              child: RecipeItem(
                name, _recipeNames.indexOf(name), deleteRecipe, editRecipe
              ),
              onTap: () => openRecipe(name)
            )  
        ).toList()
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: newRecipe,
      )

    );

  }

  //delete recipe from the list based on index
  void deleteRecipe(int index) {
    setState(() {
      _recipeNames.removeAt(index);
    });
  }

  //edit recipe from the list
  void editRecipe(int index) {
    print("Edit ${_recipeNames[index]}");
  }

  //open recipe when tapped
  void openRecipe(String name) {
    print("Open $name");
  }

  //create new recipe (change screen)
  void newRecipe() {
    print("Wahoo!");
  }
}