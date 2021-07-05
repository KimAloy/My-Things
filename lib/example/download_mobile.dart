import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

Future<void> downloadFileExample(url) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  File downloadToFile = File('${appDocDir.path}/myThing.png');

  try {
    await firebase_storage.FirebaseStorage.instance
        // .ref('uploads/logo.png')
        .refFromURL(url)
        .writeToFile(downloadToFile);
  } catch (e) {
    // e.g, e.code == 'canceled'
    print('**********this  is the error $e');
  }
}
