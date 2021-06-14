import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mythings/firebase_api/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                    onPressed: changeProfilePicture,
                  )
                : GestureDetector(
                    onTap: changeProfilePicture,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(profilePicture),
                      backgroundColor: kGrey100,
                      radius: 17.5,
                    ),
                  );
          }
        });
  }

  Future changeProfilePicture() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final User? currentUser = FirebaseAuth.instance.currentUser;
    UploadTask? task;

    // pick image from device
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    final file = File(path!);

    // upload new image to storage
    // ignore: unnecessary_null_comparison
    if (file == null) return;
    final destination = '${currentUser!.email}/profilePicture';
    task = FirebaseApi.uploadFile(destination, file);
    // print('profilePicture successfully uploaded');

    // Get image url from firebase storage
    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    final profilePictureUrl = await snapshot.ref.getDownloadURL();

    // update profile picture field in firestore
    return users
        .doc('${currentUser.uid}')
        .update({'profilePicture': profilePictureUrl})
        .then((value) => print("ProfilePicture Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
