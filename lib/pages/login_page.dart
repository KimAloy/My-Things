import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/my_constants/responsive.dart';
import 'package:mythings/widgets/forgot_password.dart';
import 'package:mythings/pages/my_loading_page.dart';
import 'package:mythings/widgets/login_text_form_filed.dart';
import 'package:mythings/widgets/root.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  String error = '';
  final _loginFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  var currentFocus;

  void unFocus() {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  late String loginPageImage;

  Future<String> loadLoginImage() async {
    String url =
        await FirebaseStorage.instance.ref('login_screen.jpg').getDownloadURL();
    // print('This is the url: $url');
    loginPageImage = url;
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadLoginImage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          // if (!snapshot.hasData) {
          return MyLoadingPage();
        } else {
          return Container(
            color: Color(0xFFDBDEE7),
            child: Center(
              child: Container(
                height: double.infinity,
                width: Responsive.isMobile(context) ? double.infinity : 600,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(loginPageImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    width: Responsive.isMobile(context) ? double.infinity : 800,
                    child: LoadingOverlay(
                      isLoading: loading,
                      opacity: 0.3,
                      progressIndicator: CircularProgressIndicator(),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: 60),
                                Text(
                                  'My Things',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: kAppGreen,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Form(
                                  key: _loginFormKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      LoginSignUpTextFormField(
                                        controller: _emailController,
                                        obscureText: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        prefixIcon: Icons.email,
                                        labelText: 'Email',
                                        validator: (val) => val.isEmpty
                                            ? 'Enter a valid email'
                                            : null,
                                      ),
                                      const SizedBox(height: 10),
                                      LoginSignUpTextFormField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        prefixIcon: Icons.lock,
                                        labelText: 'Password',
                                        validator: (val) => val.isEmpty
                                            ? 'Enter a password'
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                error == ''
                                    ? const SizedBox.shrink()
                                    : Column(
                                        children: [
                                          const SizedBox(height: 2),
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              error,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                ForgotPassword(),
                                ElevatedButton(
                                  onPressed: () async {
                                    unFocus();
                                    if (_loginFormKey.currentState!
                                        .validate()) {
                                      setState(() => loading = true);
                                      try {
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        setState(() => loading = false);
                                        if (e.code == 'user-not-found') {
                                          error =
                                              'No user found for that email.';
                                        } else if (e.code == 'wrong-password') {
                                          error = 'Wrong password.';
                                        }
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: kAppGreen),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey[100],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: -0.1,
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: kAppGreen,
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            // return SignUp();
                                            return SignUpRoot();
                                          }));
                                          // print('going to Sign up screen');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          child: Text(
                                            'Sign up',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kAppGreen,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
