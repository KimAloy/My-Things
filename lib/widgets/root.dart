import 'package:flutter/material.dart';
import 'package:mythings/models/user_model.dart';
import 'package:mythings/pages/myThings_page.dart';
import 'package:mythings/pages/login_page.dart';
import 'package:mythings/pages/sign_up_page.dart';
import 'package:provider/provider.dart';

class LoginRoot extends StatelessWidget {
  const LoginRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context);
    return user != null ? MyThingsPage() : LoginPage();
  }
}

class SignUpRoot extends StatelessWidget {
  const SignUpRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context);
    return user != null ? MyThingsPage() : SignUp();
  }
}
