import 'package:flutter/material.dart';

import './recipeItem.dart';
import '../storage/recipeStore.dart';

import 'recipeEdit.dart';

class RecipesListScreen extends StatefulWidget {
  final RecipeStore storage = RecipeStore();

  @override
  _RecipesListScreenState createState() => _RecipesListScreenState();

}

class _RecipesListScreenState extends State<RecipesListScreen> {

  //list of recipe names
  List<String> _recipeNames = [];
  bool anyRecipesExist = true;

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  void loadRecipes() {
    // load in recipe names
    widget.storage.recipeNames().then((value) {
      setState(() {
        _recipeNames = value;
        if (_recipeNames.isEmpty) anyRecipesExist = false;
      });
    });
  }

  Widget generateRecipeList() {
    if (anyRecipesExist) {
      // if recipes exist, display them as a list of interactive widgets
      return ListView(
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
      );
    }
    else {
      // if recipes do not exist, display text telling the user so
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          child: Text(
            "No recipes have been created. Try adding one!",
            style: TextStyle(
              fontSize: 20,
              
            ),
            textAlign: TextAlign.center,
          ),
          alignment: Alignment.topCenter,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //top bar of screen
      appBar: AppBar(
        title: Text("Recipe Manager")
      ),

      body: generateRecipeList(),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: newRecipe,
      )

    );
  }

  void deleteRecipe(int index) {
    // delete recipe from storage and list
    String title = _recipeNames[index];
    _recipeNames.removeAt(index);
    widget.storage.deleteRecipe(title).then((value) {
      loadRecipes();
    });
  }

  //edit recipe from the list
  void editRecipe(int index) {
    String name = _recipeNames[index];

    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) {
        return RecipeEditScreen(
          recipeTitle: name,
          editMode: true
        );
      })
    );
  }

  //open recipe when tapped
  void openRecipe(String name) {
    print("Open $name");
  }

  //create new recipe (change screen)
  void newRecipe() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) {
        return RecipeEditScreen(editMode: false);
      })
    );
  }
}