import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/widgets/my_TextFormField.dart';

class BrandName extends StatelessWidget {
  final TextEditingController controller;
  final Function validator;

  const BrandName({Key? key, required this.controller, required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: kGrey50,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Brand name*', style: kCardTitleTextStyle),
            const SizedBox(height: 8),
            MyTextFormField(
                maxLines: 1,
                labelText: 'Enter brand name*',
                controller: controller,
                validator: validator),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
