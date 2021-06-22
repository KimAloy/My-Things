import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';

class HasNoData extends StatelessWidget {
  const HasNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            'My Things',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: kAppGreen,
            ),
          ),
        ),
      ),
    );
  }
}
