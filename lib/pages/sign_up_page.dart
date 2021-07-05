import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/my_constants/responsive.dart';
import 'package:mythings/widgets/login_text_form_filed.dart';
import 'package:mythings/widgets/root.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var currentFocus;

  void unFocus() {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  final _signUpFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userPhoneNumber = TextEditingController();

  bool loading = false;
  String error = '';

  @override
  void initState() {
    _userPhoneNumber.text = '+256';
    return super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Things',
            style: TextStyle(
                // color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
        backgroundColor: kAppGreen,
        elevation: 0.0,
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          width: Responsive.isMobile(context) ? double.infinity : 600,
          child: LoadingOverlay(
            isLoading: loading,
            opacity: 0.3,
            progressIndicator: CircularProgressIndicator(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _signUpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Sign up, it's Free!",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kAppGreen),
                      ),
                      SizedBox(height: 25),
                      LoginSignUpTextFormField(
                          controller: _usernameController,
                          obscureText: false,
                          validator: (val) =>
                              val!.isEmpty ? 'Enter your name' : null,
                          labelText: 'Full name'),
                      SizedBox(height: 20),
                      LoginSignUpTextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          obscureText: false,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter valid email address';
                            } else if (EmailValidator.validate(val) == false) {
                              return 'Enter valid email address';
                            }
                            return null;
                          },
                          labelText: 'Email address*'),
                      const SizedBox(height: 20),
                      LoginSignUpTextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'Password should be at least 6 characters'
                            : null,
                        labelText: 'Password*',
                      ),
                      const SizedBox(height: 20),
                      LoginSignUpTextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        validator: (val) => val!.isEmpty ||
                                _passwordController.text !=
                                    _confirmPasswordController.text
                            ? 'Confirm password'
                            : null,
                        labelText: 'Confirm Password*',
                      ),
                      const SizedBox(height: 20),
                      error == ''
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                const SizedBox(height: 2.0),
                                Text(
                                  error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                                const SizedBox(height: 4.0),
                              ],
                            ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kAppGreen,
                        ),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            // fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          unFocus();
                          if (_signUpFormKey.currentState!.validate()) {
                            setState(() => loading = true);

                            try {
                              UserCredential result =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: _emailController.text.trim(),
                                      password:
                                          _passwordController.text.trim());

                              /// returned user from firebase
                              User? user = result.user;

                              /// Create a new user using the same UID
                              users.doc(user!.uid).set({
                                'uid': user.uid,
                                'email': _emailController.text.trim(),
                                'name': _usernameController.text.trim(),
                                'profilePicture': '',
                              });
                              print('User Added');
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (_) {
                              //   return MyThingsPage();
                              // }));
                              setState(() => loading = false);
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                if (e.code == 'weak-password') {
                                  error =
                                      'Password should be at least 6 characters';
                                } else if (e.code == 'email-already-in-use') {
                                  error =
                                      'The email is already in use by another account';
                                }
                                print(e);
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already registered?',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          InkWell(
                            splashColor: kAppGreen,
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              // Root();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                // return LoginPage();
                                return LoginRoot();
                              }));
                              // print('going to login screen');
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: kAppGreen,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // );
  }
}
