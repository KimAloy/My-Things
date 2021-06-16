import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mythings/firebase_api/firebase_api.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/pages/edit_myThing_page.dart';
import 'package:mythings/pages/myThings_page.dart';
import 'package:mythings/utils.dart';
import 'package:mythings/widgets/my_dialog.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:photo_view/photo_view.dart';

class MyThingDetailPage extends StatefulWidget {
  final DocumentSnapshot ds;

  const MyThingDetailPage({Key? key, required this.ds}) : super(key: key);

  @override
  _MyThingDetailPageState createState() => _MyThingDetailPageState();
}

class _MyThingDetailPageState extends State<MyThingDetailPage> {
  CollectionReference things = FirebaseFirestore.instance.collection('things');

  Future<void> deleteThing() async {
    if (widget.ds['itemImage'] != null) {
      FirebaseApi.deleteImage(widget.ds['itemImage']);
    }
    if (widget.ds['receiptImage'] != null) {
      FirebaseApi.deleteImage(widget.ds['receiptImage']);
    }
    await things.doc(widget.ds.id).delete();
  }

  String? percentageProgress;
  double? progress;
  bool _isDownloading = false;
  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio();
  }

  Future<List<Directory>?> _getExternalStoragePath() {
    return p.getExternalStorageDirectories(type: p.StorageDirectory.documents);
  }

  Future downloadFile() async {
    final urlReceiptImage = widget.ds['receiptImage'];
    try {
      final dirList = await _getExternalStoragePath();
      final path = dirList![0].path;
      final file = File('$path/${DateTime.now().toString()}.jpg');
      await dio.download(urlReceiptImage, file.path,
          onReceiveProgress: (rec, total) {
        setState(() {
          _isDownloading = true;
          // percentageProgress = ((rec / total) * 100).toStringAsFixed(0) + '%';
          progress = rec / total;
          print(progress);
        });
      });
      Utils.showSnackBar(context, 'Download completed');
      setState(() {
        _isDownloading = false;
      });
    } catch (e) {
      print('The error is: $e');
    }

    // /// the downloaded file doesn't show up in the device storage
    // Reference ref =
    //     FirebaseStorage.instance.refFromURL(widget.ds['receiptImage']);
    // final dir = await getApplicationDocumentsDirectory();
    // // final file = File('${dir.path}/${ref.name}');
    // final file = File('${dir.path}/${DateTime.now().toString()}');
    // await ref
    //     .writeToFile(file)
    //     .then((value) => print('*** success ***'))
    //     .catchError((error) => print("Failed to delete user: $error"));
    //
    // Utils.showSnackBar(context, 'Download completed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 4),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.download_sharp),
                    SizedBox(width: 4),
                    Text('Download'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.delete_outlined),
                    SizedBox(width: 4),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SizedBox(height: 20),
          !_isDownloading
              ? SizedBox.shrink()
              : LinearProgressIndicator(
                  value: progress,
                  valueColor: AlwaysStoppedAnimation(kAppGreen),
                  // minHeight: 10,
                  backgroundColor: Colors.white,
                ),
          Center(
            child: Container(
              // color: Colors.red,
              height: 120,
              width: 240,
              child: Hero(
                tag: widget.ds.id,
                // tag: widget.ds['itemImage'],
                child: Image.network(
                  widget.ds['itemImage'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Text(
                widget.ds['brandName'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Text(
                widget.ds['itemShortDescription'],
                textAlign: TextAlign.center,
                // maxLines: 4,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),

          /// when i use FutureBuilder it reloads this image when
          /// showing downloading progress indicator which is not desired
          // ReceiptImageDetailsPage(ds: widget.ds),
          Expanded(
            child: Container(
              // color: Colors.blue,
              // child: Image.network(widget.ds['receiptImage']),
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.white),
                imageProvider: NetworkImage(widget.ds['receiptImage']),
                // imageProvider: NetworkImage(data['receiptImage']),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  void onSelected(BuildContext context, int item)
  // async
  {
    switch (item) {
      case 0:
        // await
        // Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return EditPage(ds: widget.ds);
        }));
        // .whenComplete(() => setState(() {}));
        // setState(() {});
        break;
      case 1:
        downloadFile();
        break;
      case 2:
        showDialog(
            context: context,
            builder: (context) {
              return MyDialog(
                title: 'Permanently delete this thing?',
                onPressed: () {
                  deleteThing();
                  // Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyThingsPage()),
                      (Route<dynamic> route) => false);
                },
              );
              // return Dialog(
              //   child: Container(
              //     height: 150,
              //     margin: EdgeInsets.symmetric(horizontal: 15),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text('Permanently delete this thing?'),
              //         SizedBox(height: 8),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             OutlinedButton(
              //                 onPressed: () {
              //                   deleteThing();
              //                   // Navigator.of(context).pop();
              //                   Navigator.of(context).pushAndRemoveUntil(
              //                       MaterialPageRoute(
              //                           builder: (context) => MyThingsPage()),
              //                       (Route<dynamic> route) => false);
              //                 },
              //                 child: Text('Yes')),
              //             SizedBox(width: 25),
              //             OutlinedButton(
              //                 onPressed: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Text(
              //                   'No',
              //                   style: TextStyle(color: kAppGreen),
              //                 )),
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              // );
            });

        break;
    }
  }
}
