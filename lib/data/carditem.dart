// import 'package:flutter/material.dart';
// import 'package:jtbMusicPlayer/data/listmodel.dart';

// import '../youtubelistpage.dart';

// class CardItem extends StatelessWidget {
//   final ListItem item;


//   const CardItem({Key key, this.item}) : super(key: key);
 

//   @override
//   Widget build(BuildContext context) {
//     return Card( //                           <-- Card widget
//       child: ListTile(
        
//       // leading: Icon(),
//       title: Text(item.title),
//         onTap: (){
//           Navigator.of(context).push(MaterialPageRoute(builder: (context) => YoutubeListPage( title: item.title,)));
//         },
//       ),
//     );
//   }
// }