import 'package:flutter/material.dart';

import 'draft_length_widget.dart';

class MyMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Row(
        children: [
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer()),
          DraftLengthWidget(),
        ],
      ),
    );
  }
}
