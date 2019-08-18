import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child : ListView.builder(
        itemCount: 10,
        itemBuilder: (context, position){
          return Card(
            child:Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                position.toString(),style: TextStyle(fontSize:22.0),
              ),
            ),
          );
        },
      )
    );
  }
}