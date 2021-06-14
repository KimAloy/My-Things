import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mythings/firebase_api/auth.dart';
import 'package:mythings/models/user_model.dart';
import 'package:mythings/widgets/root.dart';
import 'package:provider/provider.dart';
import 'my_constants/my_constants.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserModel?>.value(
          catchError: (_, __) => null,
          value: Auth().user,
          initialData: null,
        ),
        // ChangeNotifierProvider<MyThingsProvider>(
        //   create: (context) => MyThingsProvider(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: kAppGreen,
            scaffoldBackgroundColor: Colors.white),
        home: LoginRoot(),
      ),
    );
  }
}
