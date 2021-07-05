import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mythings/pages/myThings_page.dart';
import 'package:mythings/pages/login_page.dart';
import 'package:mythings/pages/sign_up_page.dart';
import 'package:mythings/repositories/auth_service.dart';

import '../pages/my_loading_page.dart';

class LoginRoot extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _authState = watch(authStateProvider);
    return _authState.when(
        data: (val) => val != null ? MyThingsPage() : LoginPage(),
        loading: () => MyLoadingPage(),
        error: (error, stack) {
          // print('*******actual error********');
          return Scaffold(body: Center(child: Text('Oops!')));
        });
  }
}

class SignUpRoot extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _authState = watch(authStateProvider);
    return _authState.when(
        data: (val) => val != null ? MyThingsPage() : SignUp(),
        loading: () => MyLoadingPage(),
        error: (error, stack) {
          // print('*******actual error********');
          return Scaffold(body: Center(child: Text('Oops!')));
        });
  }
}
