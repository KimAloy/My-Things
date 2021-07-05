// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mythings/repositories/myFilePickerAPIs.dart';
import 'package:mythings/my_constants/my_constants.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? loggedInUser = FirebaseAuth.instance.currentUser;
    final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc('${loggedInUser!.uid}')
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something Went Wrong Try later');
          }
          if (!snapshot.hasData) {
            return Container();
          } else {
            // DocumentSnapshot data = snapshot.data!
            String profilePicture = snapshot.data!['profilePicture'];
            // ignore: unrelated_type_equality_checks
            return profilePicture == ''
                ? IconButton(
                    icon: Icon(
                      Icons.account_circle_outlined,
                      size: 35,
                    ),
                    onPressed: kIsWeb
                        ? changeProfilePictureWeb
                        : MyFilePickerAPIs.changeProfilePictureMobile,
                  )
                : GestureDetector(
                    onTap: kIsWeb
                        ? changeProfilePictureWeb
                        : MyFilePickerAPIs.changeProfilePictureMobile,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(profilePicture),
                      backgroundColor: kGrey100,
                      radius: 17.5,
                    ),
                  );
          }
        });
  }

  changeProfilePictureWeb() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final User? currentUser = FirebaseAuth.instance.currentUser;

    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input..click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        final snapshot =
            await fs.ref('${currentUser!.email}/profilePicture').putBlob(file);
        //  get download url
        final profilePictureUrl = await snapshot.ref.getDownloadURL();
        // update profile picture field in firestore
        return users
            .doc('${currentUser.uid}')
            .update({'profilePicture': profilePictureUrl});
        // .then((value) => print("ProfilePicture Updated"))
        // .catchError((error) => print("Failed to update user: $error"));
      });
    });
  }
}
