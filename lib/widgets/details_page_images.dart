import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:photo_view/photo_view.dart';

class MyItemOnDetailsPage extends StatelessWidget {
  final DocumentSnapshot ds;

  const MyItemOnDetailsPage({Key? key, required this.ds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _newDocumentStream =
        FirebaseFirestore.instance.collection('things').doc(ds.id).snapshots();
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
          var itemImage = snapshot.data!['itemImage'];
          var receiptImage = snapshot.data!['receiptImage'];
          var brandName = snapshot.data!['brandName'];
          var itemShortDescription = snapshot.data!['itemShortDescription'];

          return Container(
            // color: Colors.red,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                itemImage == null
                    ? Container(
                        height: 120,
                        width: 240,
                        color: kGrey100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 30,
                              color: Colors.black38,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'No image',
                              style: TextStyle(color: Colors.black38),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        // color: Colors.red,
                        height: 120,
                        width: 240,
                        child: Hero(
                          tag: ds.id,
                          child: Image.network(
                            itemImage,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: Text(
                      brandName,
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
                      itemShortDescription,
                      textAlign: TextAlign.center,
                      // maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 300,
                  height: 400,
                  // color: Colors.blue,
                  child: PhotoView(
                    backgroundDecoration: BoxDecoration(color: Colors.white),
                    imageProvider: NetworkImage(receiptImage),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
