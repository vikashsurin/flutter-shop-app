import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../screens/edit_product_screen.dart';

class userProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const userProductItem(
      {Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (e) {
                  scaffold.showSnackBar(const SnackBar(
                      content: Text(
                    'Deletion failed!',
                    textAlign: TextAlign.center,
                  )));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
