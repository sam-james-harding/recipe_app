import 'package:flutter/material.dart';

class DescriptionTab extends StatelessWidget {

  final String title;
  final String description;

  final Function(String) onTitleChange;
  final Function(String) onDescriptionChange;
  final Function onSaveButtonPress;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DescriptionTab({
    required this.title,
    required this.description,
    required this.onTitleChange,
    required this.onDescriptionChange,
    required this.onSaveButtonPress
  });

  @override
  Widget build(BuildContext context) {

    _titleController.text = title;
    _descriptionController.text = description;

    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Title", style: TextStyle(fontSize: 20)),
        ),
        
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter a title for your recipe..."
          ),
          onChanged: onTitleChange,
          controller: _titleController
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Description", style: TextStyle(fontSize: 20)),
        ),

        Expanded(child:
        TextField(
          expands: true,
          maxLines: null,
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter a description for your recipe..."
          ),
          onChanged: onDescriptionChange,
          controller: _descriptionController
        )
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            child: ElevatedButton(
              child: Text("Save Recipe"),
              onPressed: () => onSaveButtonPress(),
            ),
            constraints: const BoxConstraints(minWidth: double.infinity)
          ),
        )

      ]
    );

  }

}