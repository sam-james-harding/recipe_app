import 'package:flutter/material.dart';

class ListEditWidget extends StatefulWidget {

  final List<String> items;

  ListEditWidget(this.items);

  _ListEditWidgetState createState() => _ListEditWidgetState();

}

class _ListEditWidgetState extends State<ListEditWidget> {

  late List<String> _items;

  @override
  void initState() {
    _items = List.from(widget.items);

    super.initState();
  }

  Widget entriesDisplay() {
    if (_items.isEmpty == false) {
      // if items exist, display them

      return Expanded(
        child: ListView(
          children: _items.map(
            (item) => _ListEditItem(item)
          ).toList()
        )
      );

    }

    else {
      return Expanded(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          child: Text(
            "No items have been entered. Try adding one!",
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
      _BottomTextEntry()
    ]);

  }

}

class _BottomTextEntry extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(children: [
          Expanded(child: TextField()),
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () {},
            color: Colors.blue,
          )
        ])
      ),
    );

  }

}

class _ListEditItem extends StatelessWidget {

  final String text;
  final TextEditingController _controller = TextEditingController();

  _ListEditItem(this.text);

  @override
  Widget build(BuildContext context) {

    _controller.text = text;

    return Card(
      child: Row(children: [

        Expanded(
          child: TextField(
            controller: _controller,
          )
        ),

        IconButton(
          icon: Icon(Icons.remove),
          color: Colors.red,
          onPressed: () {},
        )

      ])
    );

  }

}