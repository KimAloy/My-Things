import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/repositories/utils.dart';

class UploadImageMobileWidget extends StatelessWidget {
  final Function onTap;
  final String title;
  final File? file;

  const UploadImageMobileWidget({
    Key? key,
    required this.onTap,
    required this.title,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(title, style: kCardTitleTextStyle),
                  Spacer(),
                  Icon(Icons.file_upload),
                ],
              ),
              // ignore: unnecessary_null_comparison
              file == null
                  ? const SizedBox.shrink()
                  : Container(
                      height: 100,
                      width: 100,
                      child: Image.file(file!),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadImageWebWidget extends StatelessWidget {
  final Function onTap;
  final String title;
  final file;
  final double? height;
  final double? width;

  const UploadImageWebWidget({
    Key? key,
    required this.onTap,
    required this.title,
    required this.file,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UploadTask? task;
    // print('we are on web ************');
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: kCardTitleTextStyle),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.camera_alt_outlined,
                      // size: 30,
                      color: Colors.black38,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                // ignore: unnecessary_null_comparison
                file == null
                    ? Container(
                        height: height ?? 120,
                        width: width ?? 240,
                        color: kGrey100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 30,
                              color: Colors.black38,
                            ),
                            Text('No image',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black38,
                                )),
                          ],
                        ),
                      )
                    : Container(
                        height: height ?? 120,
                        width: width ?? 240,
                        child: Image.network(file!),
                      ),
                task != null ? buildUploadStatus(task) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          return Text(
            '$progress %',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          );
        } else {
          return Container();
        }
      });
}

class UploadImageWebController extends StatelessWidget {
  final String currentDocId;
  final String docField;
  final String title;
  final double? height;
  final double? width;

  const UploadImageWebController({
    Key? key,
    required this.currentDocId,
    required this.title,
    required this.docField,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _newDocumentStream = FirebaseFirestore
        .instance
        .collection('things')
        .doc(currentDocId)
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: _newDocumentStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something Went Wrong Try later');
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            // CAUTION: don't change this to a String, leave it as 'var'
            var imageField = snapshot.data!['$docField'];
            return UploadImageWebWidget(
              file: imageField,
              onTap: () => Utils.updateImageWeb(
                id: currentDocId,
                docField: docField,
              ),
              title: title,
              height: height,
              width: width,
            );
          }
        });
  }
}
