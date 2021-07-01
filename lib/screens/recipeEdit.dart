import 'package:flutter/material.dart';

import '../widgets/listEditor.dart';
import '../widgets/descriptionTab.dart';

import 'recipesList.dart';
import 'recipeView.dart';

import '../storage/recipeStore.dart';


class RecipeEditScreen extends StatefulWidget {

  final String? recipeTitle;
  final bool editMode;
  final bool fromListScreen;

  final RecipeStore storage = RecipeStore();

  RecipeEditScreen({
    required this.editMode,
    required this.fromListScreen,
    this.recipeTitle,
  });

  @override
  _RecipeEditScreenState createState() => _RecipeEditScreenState();

}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  List steps = [];
  List ingredients = [];
  String description = "";
  String title = "";

  int _selectedTabIndex = 0;

  late Widget currentTab;

  void _setTab(int index) {
    setState(() {
      if (index == 0) {
        currentTab = DescriptionTab(
          title: title,
          description: description,
          onTitleChange: onTitleChange,
          onDescriptionChange: onDescriptionChange,
          onSaveButtonPress: saveData,
        );
      }
      else if (index == 1) {
        currentTab = ListEditWidget(ingredients);
      }
      else if (index == 2) {
        currentTab = ListEditWidget(steps);
      }

      _selectedTabIndex = index; //set index to new index
    });
  }

  @override
  void initState() {
    _setTab(0);

    if (widget.editMode == true) populateFields();

    super.initState();
  }

  void populateFields() async {
    final recipeJSON = await widget.storage.getRecipe(widget.recipeTitle!);

    title = recipeJSON.title;
    description = recipeJSON.description;
    steps = recipeJSON.steps;
    ingredients = recipeJSON.ingredients;

    _setTab(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Edit Recipe"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => close(),
        )
      ),

      body: currentTab,

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: "Recipe"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Ingredients"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Steps"
          )
        ],

        currentIndex: _selectedTabIndex,
        onTap: _setTab,
      ),

    );
  }

  void returnToLastWindow() {
    if (widget.fromListScreen) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => RecipesListScreen())
      );
    }
    else {
      widget.storage.getRecipe(title).then((value) => {
        Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => RecipeViewScreen(recipe: value))
      )
      });
    }
  }

  void close() {

    Future<bool?> shouldClose = showDialog<bool>(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: Text("Close Recipe"),
        content: Text("Are you sure you want to close without saving?"),

        actions: <Widget>[
          TextButton(child: Text("Cancel"), 
            onPressed: () => Navigator.pop(context, false)
          ),

          TextButton(child: Text("OK"), 
            onPressed: () => Navigator.pop(context, true)
          )
        ]
      )
    );

    shouldClose.then((result) => returnToLastWindow());
  }

  void onTitleChange(String newTitle) {title = newTitle;}
  void onDescriptionChange(String newDescription) {description = newDescription;}

  void saveData() {
    widget.storage.recipeNames().then((recipeNames) {
    print(recipeNames);
    print(recipeNames.contains(widget.recipeTitle));
    if ((title == "") || (description == "") || (steps.isEmpty) || (ingredients.isEmpty)) {
      showDialog(
        context: context, 
        builder: (BuildContext context) => AlertDialog(
          title: Text("More Data Required"),
          content: Text("Not all fields have been filled. "
            "Please ensure you have a title, a description, ingredients and steps.")
        )
      );
    }

    else if (recipeNames.contains(title) && ((widget.editMode == false) || (widget.recipeTitle != title))) {
      showDialog(
        context: context, 
        builder: (BuildContext context) => AlertDialog(
          title: Text("Name Already in Use"),
          content: Text("This recipe name is already in use. Please choose another one.")
        )
      );
    }
    
    else {
      Recipe newRecipe = Recipe(
        title: title,
        description: description,
        steps: steps,
        ingredients: ingredients
      );

      if (widget.editMode) {
        widget.storage.deleteRecipe(widget.recipeTitle!).then((value) => {
          widget.storage.writeRecipe(newRecipe).then((value) => returnToLastWindow())
        });
      }
      else {
        widget.storage.writeRecipe(newRecipe).then((value) => returnToLastWindow());
      }
    }
    });
  }
}