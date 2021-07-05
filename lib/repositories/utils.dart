// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';

import 'firebase_api.dart';

class Utils {
  static void showSnackBar(BuildContext context, String text) =>
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: kAppGreen,
            content: Text(text),
          ),
        );

  static DateTime toDateTime(Timestamp value) {
    // if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    // if (date == null) return null;

    return date.toUtc();
  }

  static void selectAndUploadImageWeb(
      {required String updateDocField, required String doc}) async {
    CollectionReference _things =
        FirebaseFirestore.instance.collection('things');
    final User? currentUser = FirebaseAuth.instance.currentUser;

    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input..click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        final snapshot = await fs
            .ref('${currentUser!.email}/${DateTime.now().toString()}')
            .putBlob(file);
        //  get download url
        final downloadUrl = await snapshot.ref.getDownloadURL();
        // update receipt image field in firestore
        return _things.doc(doc).update({updateDocField: downloadUrl});
        // .then((value) => print("ProfilePicture Updated"))
        // .catchError((error) => print("Failed to update user: $error"));
      });
    });
  }

  static Future<void> deleteThing({required DocumentSnapshot ds}) async {
    CollectionReference things =
        FirebaseFirestore.instance.collection('things');
    // if (ds['brandName'] == null) {
    if (ds['itemImage'] != null) {
      FirebaseApi.deleteImage(ds['itemImage']);
    }
    if (ds['receiptImage'] != null) {
      FirebaseApi.deleteImage(ds['receiptImage']);
    }
    await things.doc(ds.id).delete();
  }

  static Future<void> updateImageWeb(
      {required String id, required String docField}) async {
    final currentDoc =
        await FirebaseFirestore.instance.collection('things').doc('$id').get();
    if (currentDoc[docField] != null) {
      FirebaseApi.deleteImage(currentDoc[docField]);
      Utils.selectAndUploadImageWeb(
        updateDocField: docField,
        doc: '$id',
      );
    } else {
      Utils.selectAndUploadImageWeb(
        updateDocField: docField,
        doc: '$id',
      );
    }
  }
}
