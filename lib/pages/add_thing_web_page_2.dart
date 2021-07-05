import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/pages/myThings_page.dart';
import 'package:mythings/my_constants/responsive.dart';
import 'package:mythings/repositories/utils.dart';
import 'package:mythings/widgets/upload_image_widget.dart';

class AddThingWebPage2 extends StatefulWidget {
  final String currentDocId;

  const AddThingWebPage2({Key? key, required this.currentDocId})
      : super(key: key);

  @override
  _AddThingWebPage2State createState() => _AddThingWebPage2State();
}

class _AddThingWebPage2State extends State<AddThingWebPage2> {
  bool loading = false;

  var currentFocus;

  void unFocus() {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  final User? loggedInUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _newDocumentStream = FirebaseFirestore
        .instance
        .collection('things')
        .doc(widget.currentDocId)
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
            var receiptImage = snapshot.data!['receiptImage'];

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: kAppGreen,
                title: Row(
                  children: [
                    Text('Add Thing'),
                    Spacer(),
                    Text('2'),
                  ],
                ),
                elevation: 0,
              ),
              body: LoadingOverlay(
                isLoading: loading,
                opacity: 0.3,
                progressIndicator: CircularProgressIndicator(),
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      width:
                          Responsive.isMobile(context) ? double.infinity : 600,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 15),
                          UploadImageWebController(
                            currentDocId: widget.currentDocId,
                            title: 'Upload receipt photo*',
                            docField: 'receiptImage',
                            height: 240,
                            width: 120,
                          ),
                          SizedBox(height: 15),
                          UploadImageWebController(
                            currentDocId: widget.currentDocId,
                            title: 'Upload item photo*',
                            docField: 'itemImage',
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    unFocus();

                                    setState(() => loading = true);

                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyThingsPage()),
                                        (Route<dynamic> route) => false);
                                    receiptImage == null
                                        ? Utils.showSnackBar(
                                            context, 'Saved to Drafts')
                                        : Utils.showSnackBar(
                                            context, 'Success!');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    child: Text('Add Thing',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: kAppGreen),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
