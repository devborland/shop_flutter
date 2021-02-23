import 'package:flutter/material.dart';

class UserProductItemWidget extends StatelessWidget {
  final String title;
  final String imageUrl;

  UserProductItemWidget({
    this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  //...
                }),
            IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  //...
                }),
          ],
        ),
      ),
    );
  }
}
