import 'package:flutter/material.dart';

import 'listEditor.dart';

import '../storage/recipeStore.dart';

class RecipeEditScreen extends StatefulWidget {

  final String? recipeTitle;
  final bool editMode;

  RecipeEditScreen({
    required this.editMode,
    this.recipeTitle
  });

  @override
  _RecipeEditScreenState createState() => _RecipeEditScreenState();

}

class _RecipeEditScreenState extends State<RecipeEditScreen> {

  late ListEditWidget ingredientsWidget;
  late ListEditWidget stepsWidget;

  List<String> ingredients = [];
  List<String> steps = [];

  @override
  void initState() {
    if (widget.editMode == true) populateFields();

    ingredientsWidget = ListEditWidget(ingredients);
    stepsWidget = ListEditWidget(steps);

    super.initState();
  }

  void populateFields() {
    //TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Edit Recipe"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => close(context),
        )
      ),

      body: stepsWidget,

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
        ]
      ),

    );
  }

  void close(BuildContext context) {

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

    shouldClose.then((result) {
      if (result == true) {
        Navigator.pop(context);
      }
    });

  }
}