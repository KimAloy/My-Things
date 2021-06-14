import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/pages/reset_password_page.dart';

class ForgotPassword extends StatelessWidget {
  final Color? color;
  const ForgotPassword({
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          splashColor: kAppGreen,
          borderRadius: BorderRadius.circular(3),
          onTap: () {
            print('Forgot password tapped');
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return ResetPassword();
            }));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: Text(
              'Forgot password',
              style: TextStyle(fontWeight: FontWeight.w600, color: color),
              // textAlign: TextAlign.end,
            ),
          ),
        ),
      ],
    );
  }
}
