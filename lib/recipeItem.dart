import 'package:flutter/material.dart';

class RecipeItem extends StatelessWidget {

  final String name;
  final int index;

  final Function(int) onDelete;
  final Function(int) onEdit;

  RecipeItem(this.name, this.index, this.onDelete, this.onEdit);

  @override
  Widget build(BuildContext context) {

    return Card(child: ListTile(
      leading: Icon(Icons.fastfood),
      title: Text(name),

      trailing: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => onEdit(index), 
            icon: Icon(Icons.edit)
          ),

          IconButton(
            onPressed: () => deleteRecipe(context), 
            icon: Icon(Icons.delete)
          )
        ],

        mainAxisSize: MainAxisSize.min
      )

    ));

  }

  void deleteRecipe(BuildContext context) {
    //create dialog to confirm deletion, and get result value as future bool
    var shouldDelete = showDialog<bool>(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: Text("Delete Recipe"),
        content: Text("Are you sure you want to delete the recipe: $name?"),

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

    //if OK is pressed, delete self using passed onDelete function
    shouldDelete.then((value) => {
      if (value == true) {onDelete(index)}
    });

  }

}