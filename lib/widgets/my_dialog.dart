import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';

class MyDialog extends StatelessWidget {
  final Function onPressed;
final String title;
  const MyDialog({Key? key,required this.title, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: onPressed as void Function()?,
                    child: Text('Yes')),
                SizedBox(width: 25),
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'No',
                      style: TextStyle(color: kAppGreen),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
