import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/widgets/my_TextFormField.dart';

class MyDate extends StatelessWidget {
  final TextEditingController monthController;
  final TextEditingController yearController;
  final String title;
  final yearValidator;
  // final monthValidator;

  const MyDate({
    Key? key,
    required this.monthController,
    required this.yearController,
    required this.title,
    required this.yearValidator,
    // required this.monthValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: kCardTitleTextStyle),
            SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  child: MyTextFormField(
                    // validator: monthValidator,
                    validator: (value) => value.isEmpty ||
                            int.parse(value) > 12 ||
                            value.length > 2
                        ? 'Month'
                        : null,
                    controller: monthController,
                    keyboardType: TextInputType.number,
                    labelText: 'MM',
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 70,
                  child: MyTextFormField(
                    validator: yearValidator,
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    labelText: 'YYYY',
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
