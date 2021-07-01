import 'package:flutter/material.dart';

class ListEditWidget extends StatefulWidget {

  final List items;
  final _ListEditWidgetState state = _ListEditWidgetState();

  ListEditWidget(this.items);

  _ListEditWidgetState createState() => state;

}

class _ListEditWidgetState extends State<ListEditWidget> {
  Widget entriesDisplay() {
    if (widget.items.isEmpty == false) {
      // if items exist, display them

      return Expanded(
        child: ListView(

          children: widget.items.asMap().entries.map((item) => 
            Container(
              key: UniqueKey(),
              child: _ListEditItem(
                text: item.value,
                index: item.key, 
                onRemove: removeItem,
                onChangeSubmitted: changeItem,
              )
            )
          ).toList()
        )
      );

    }

    else {
      return Expanded(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          child: Text(
            "No items have been entered. Try adding some!",
            style: TextStyle(
              fontSize: 20,
              
            ),
            textAlign: TextAlign.center,
          ),
          alignment: Alignment.topCenter,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(children: [
      entriesDisplay(),
      _BottomTextEntry(onSubmit: addItem)
    ]);

  }

  void addItem(String itemText) {
    if (itemText != "") {
      setState(() {widget.items.add(itemText);});
    }
    else {
      showDialog(
        context: context, 
        builder: (BuildContext context) => AlertDialog(
          title: Text("No Text Written"),
          content: Text("Please write some text before you submit the new item.")
        )
      );
    }
  }

  void removeItem(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  void changeItem(int index, String newValue) {
    widget.items[index] = newValue;
  }

}

class _BottomTextEntry extends StatelessWidget {

  final TextEditingController _controller = TextEditingController();

  final Function(String) onSubmit;

  _BottomTextEntry({
    required this.onSubmit
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(children: [

          Expanded(
            child: TextField(
              controller: _controller,
            )
          ),

          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () => onSubmit(_controller.text),
            color: Colors.blue,
          )

        ])
      ),
    );

  }

}

class _ListEditItem extends StatelessWidget {

  final TextEditingController _controller = TextEditingController();

  final String text;
  final int index;

  final Function(int) onRemove;
  final Function(int, String) onChangeSubmitted;

  _ListEditItem({
    required this.text,
    required this.index,
    required this.onRemove,
    required this.onChangeSubmitted
  });

  @override
  Widget build(BuildContext context) {

    _controller.text = text;

    return Card(
      child: ListTile(
        title: TextField(
            controller: _controller,
            onChanged: (value) => onChangeSubmitted(index, value),
          ),

        //remove button
        trailing: IconButton(
          icon: Icon(Icons.remove),
          color: Colors.red,
          onPressed: () => onRemove(index),
        ),
      )
    );

  }

}