import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'firebase_api.dart';

class MyFilePickerAPIs {
  static Future changeProfilePictureMobile() async {
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
        .update({'profilePicture': profilePictureUrl});
    // .then((value) => print("ProfilePicture Updated"))
    // .catchError((error) => print("Failed to update user: $error"));
  }
}
