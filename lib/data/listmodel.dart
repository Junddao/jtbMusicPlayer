
import 'package:flutter/material.dart';

class ListModel<E>{
  final List<E> _items;

  ListModel({@required Iterable<E> initialItems})
  : assert( initialItems != null),
   _items = List<E>.from(initialItems ?? <E>[]);

  void insert(int index, E item){
    _items.insert(index, item);
  }

  E removeAt(int index){
    final removeItem = _items.removeAt(index);
    return removeItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}


class ListItem{

  int id;
  String title;

  ListItem( this.id, this.title);

  ListItem.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
  } 
  
  Map<String, dynamic> toMap() => { 
    "id": id,
    "title": title, 
  };
}