import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mythings/firebase_api/firebase_api.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/pages/myThings_page.dart';
import 'package:mythings/utils.dart';
import 'package:mythings/widgets/brand_name.dart';
import 'package:mythings/widgets/edit_page_photoFromFirestore.dart';
import 'package:mythings/widgets/itemDetails.dart';
import 'package:mythings/widgets/my_date.dart';
import 'package:mythings/widgets/upload_image_widget.dart';

class EditPage extends StatefulWidget {
  final DocumentSnapshot ds;

  const EditPage({Key? key, required this.ds}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String? itemDescription;
  String? brandName;
  String? expiryMonth;
  String? expiryYear;
  String? purchaseMonth;
  String? purchaseYear;
  String? itemImageUrl;
  String? receiptImageUrl;

  late String documentID;

  File? receiptPhotoFile;
  File? itemPhotoFile;
  bool loading = false;
  bool generalError = false;

  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final User? loggedInUser = FirebaseAuth.instance.currentUser;
  final currentDate = DateTime.now();

  var currentFocus;

  void unFocus() {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    itemDescription = widget.ds['itemShortDescription'];
    brandName = widget.ds['brandName'];
    expiryMonth = Utils.toDateTime(widget.ds['expiryDate'])!.month.toString();
    expiryYear = Utils.toDateTime(widget.ds['expiryDate'])!.year.toString();
    purchaseMonth =
        Utils.toDateTime(widget.ds['purchaseDate'])!.month.toString();
    purchaseYear = Utils.toDateTime(widget.ds['purchaseDate'])!.year.toString();
    itemImageUrl = widget.ds['itemImage'];
    receiptImageUrl = widget.ds['receiptImage'];
  }

  @override
  Widget build(BuildContext context) {
    final itemDescriptionController =
        TextEditingController(text: itemDescription);
    final brandNameController = TextEditingController(text: brandName);
    final expiryMonthController = TextEditingController(text: expiryMonth);
    final expiryYearController = TextEditingController(text: expiryYear);
    final purchaseMonthController = TextEditingController(text: purchaseMonth);
    final purchaseYearController = TextEditingController(text: purchaseYear);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kAppGreen,
        title: Text('Edit'),
        elevation: 0,
      ),
      body: LoadingOverlay(
        isLoading: loading,
        opacity: 0.3,
        progressIndicator: CircularProgressIndicator(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BrandName(
                    controller: brandNameController,
                    validator: (text) =>
                        text.isEmpty ? 'Please enter a Brand name*' : null),
                SizedBox(height: 8),
                ItemDetails(controller: itemDescriptionController),
                SizedBox(height: 8),
                MyDate(
                  title: 'Guarantee expiry date*',
                  monthController: expiryMonthController,
                  yearController: expiryYearController,
                  yearValidator: (value) =>
                      value.isEmpty || value.length != 4 ? 'Year' : null,
                ),
                SizedBox(height: 8),
                MyDate(
                  title: 'Purchase date*',
                  monthController: purchaseMonthController,
                  yearController: purchaseYearController,
                  yearValidator: (value) => value.isEmpty ||
                          int.parse(value) > currentDate.year ||
                          value.length != 4
                      ? 'Year'
                      : null,
                ),
                SizedBox(height: 8),
                receiptPhotoFile == null
                    ? ImageFromFirestoreWidget(
                        onTap: () {
                          selectReceiptFile();
                        },
                        title: 'Upload receipt photo*',
                        image: widget.ds['receiptImage'])
                    : UploadImageWidget(
                        file: receiptPhotoFile,
                        onTap: () {
                          selectReceiptFile();
                          // print('upload receipt tapped');
                        },
                        title: 'Upload receipt photo*',
                      ),
                SizedBox(height: 8),
                itemPhotoFile == null
                    ? ImageFromFirestoreWidget(
                        onTap: () {
                          selectItemPhotoFile();
                        },
                        title: 'Upload item photo*',
                        image: widget.ds['itemImage'])
                    : UploadImageWidget(
                        file: itemPhotoFile,
                        onTap: () {
                          selectItemPhotoFile();
                          // print('upload item widget tapped');
                        },
                        title: 'Upload item photo*',
                      ),
                const SizedBox(height: 4.0),
                SizedBox(height: 15),
                generalError == false
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          const SizedBox(height: 2.0),
                          Text(
                            'Please fill in the fields marked *',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    // onPressed: addThing,
                    onPressed: () async {
                      unFocus();
                      final isValid = _formKey.currentState!.validate();
                      if (!isValid) {
                        generalError = true;
                        return;
                      } else {
                        setState(() => loading = true);
                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        final User? currentUser = _auth.currentUser;

                        UploadTask? task;

                        /// update receiptImage in Firestore & Firebase Storage
                        if (receiptPhotoFile != null) {
                          // delete current image from storage
                          FirebaseApi.deleteImage(widget.ds['receiptImage']);

                          // upload new image to storage
                          final destination =
                              '${currentUser!.email}/${DateTime.now().toString()}';
                          task = FirebaseApi.uploadFile(
                              destination, receiptPhotoFile!);
                          // print('receiptPhotoFile successfully uploaded');

                          // Get image url from firebase storage
                          if (task == null) return;
                          final snapshot = await task.whenComplete(() {});
                          receiptImageUrl = await snapshot.ref.getDownloadURL();
                        }

                        /// update itemPhotoFile to Firebase Storage
                        if (itemPhotoFile != null) {
                          // delete current image from storage
                          FirebaseApi.deleteImage(widget.ds['itemImage']);

                          // upload new image to storage
                          final destination =
                              '${currentUser!.email}/${DateTime.now().toString()}';
                          task = FirebaseApi.uploadFile(
                              destination, itemPhotoFile!);
                          // print('itemPhotoFile successfully uploaded');

                          // Get image url from firebase storage
                          if (task == null) return;
                          final snapshot = await task.whenComplete(() {});
                          itemImageUrl = await snapshot.ref.getDownloadURL();
                        }

                        _firestore
                            .collection('things')
                            // .doc(documentID)
                            .doc(widget.ds.id)
                            .update({
                          'userEmail': widget.ds['userEmail'],
                          // 'itemImage': widget.ds['itemImage'] ??
                          'itemImage': itemImageUrl,
                          'receiptImage': receiptImageUrl,
                          'itemShortDescription':
                              null ?? itemDescriptionController.text,
                          'brandName': brandNameController.text,
                          'expiryDate': DateTime(
                              int.parse(expiryYearController.text),
                              int.parse(expiryMonthController.text)),
                          'purchaseDate': DateTime(
                              int.parse(purchaseYearController.text),
                              int.parse(purchaseMonthController.text)),
                        });
                        // .then((value) => print('successfully edited'))
                        // .catchError((onError) =>
                        //     print('this is the error: $onError'));
                        // Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => MyThingsPage()),
                            (Route<dynamic> route) => false);
                        Utils.showSnackBar(context, 'Successfully Edited');
                      }
                    },
                    child: Text('Save Changes'),
                    style: ElevatedButton.styleFrom(primary: kAppGreen),
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectReceiptFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() => receiptPhotoFile = File(path!));
  }

  void selectItemPhotoFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() => itemPhotoFile = File(path!));
  }
}
