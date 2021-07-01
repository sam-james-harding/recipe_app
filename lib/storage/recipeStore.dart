import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

// test save dir:
// /Users/sam/Library/Developer/CoreSimulator/Devices/E0320206-C8DC-44B7-A59B-8B13D617AF58/data/Containers/Data/Application/F090A30B-32F2-4430-80DC-2C9E70E3908F/Documents/recipes 


class RecipeStore {

  Future<File> get _recipeNamesFile async {
    //get directory of file
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    File recipeNamesFile = File("$path/recipes/recipeNames.txt");

    //create file only if it does not exist already
    bool fileExists = await recipeNamesFile.exists();
    if (!fileExists) {
      await recipeNamesFile.create(recursive: true);
    }

    //return file
    return recipeNamesFile;
  }

  Future<File> _recipeFile(String title) async {
    //get directory of file
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    File recipeFile = File("$path/recipes/$title.json");

    //create file only if it does not exist already
    bool fileExists = await recipeFile.exists();
    if (!fileExists) {
      await recipeFile.create(recursive: true);
    }

    //return file
    return recipeFile;
  }

  /* Dealing with recipe names list 
  The list is stored in a .txt file as a newline-separated list,
  so for getting, it must be split by newlines, and for setting,
  joined with newlines. */

  Future<List<String>> recipeNames() async {
    final file = await _recipeNamesFile;
    final contents = await file.readAsString();

    if (contents == "") return [];
    else return contents.split("\n");
  }

  Future<File> setRecipeNames(List<String> names) async {
    final file = await _recipeNamesFile;

    final namesString = names.join("\n");

    return file.writeAsString(namesString);
  }

  /* Dealing with individual recipes
  These are stored in json files*/
  Future<File> writeRecipe(Recipe recipe) async {
    //get json data
    final file = await _recipeFile(recipe.title);
    final jsonData = recipe.toJSON();
    final encodedJSON = jsonEncode(jsonData);

    //add to list
    List<String> names = await recipeNames();
    names.add(recipe.title);
    await setRecipeNames(names);

    //write json data
    return file.writeAsString(encodedJSON);
  }

  Future<Recipe> getRecipe(String title) async {
    final file = await _recipeFile(title);
    final contents = await file.readAsString();
    final jsonData = jsonDecode(contents);

    return Recipe(
      title: jsonData["title"] as String,
      description: jsonData["description"] as String,
      ingredients: jsonData["ingredients"] as List,
      steps: jsonData["steps"] as List
    );
  }

  Future deleteRecipe(String title) async {
    //delete file
    final file = await _recipeFile(title);
    await file.delete();

    //remove from list
    List<String> names = await recipeNames();
    names.remove(title);
    await setRecipeNames(names);
  }

}

class Recipe {
  final String title;
  final String description;
  final List ingredients;
  final List steps;

  Recipe({
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps
  });

  Map<String, dynamic> toJSON() => {
    "title": title,
    "description": description,
    "ingredients": ingredients,
    "steps": steps
  };
}