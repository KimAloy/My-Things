import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mythings/models/item_model.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/my_constants/responsive.dart';
import 'package:mythings/repositories/utils.dart';
import 'package:mythings/widgets/brand_name.dart';
import 'package:mythings/widgets/itemDetails.dart';
import 'package:mythings/widgets/my_date.dart';
import 'package:mythings/widgets/upload_image_widget.dart';

class EditPage extends StatefulWidget {
  // final DocumentSnapshot? ds;
  final Item item;
  const EditPage({
    Key? key,
    required this.item,
    // this.ds,
  }) : super(key: key);

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
    // Here we use Item class
    itemDescription = widget.item.itemShortDescription;
    brandName = widget.item.brandName;
    expiryMonth = widget.item.expiryDate.month.toString();
    expiryYear = widget.item.expiryDate.year.toString();
    purchaseMonth = widget.item.purchaseDate.month.toString();
    purchaseYear = widget.item.purchaseDate.year.toString();
    itemImageUrl = widget.item.itemImage;
    receiptImageUrl = widget.item.receiptImage;
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

    final Stream<DocumentSnapshot> _newDocumentStream = FirebaseFirestore
        .instance
        .collection('things')
        .doc(widget.item.id)
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
                title: Text('Edit'),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),
                            BrandName(
                                controller: brandNameController,
                                validator: (text) => text.isEmpty
                                    ? 'Please enter a Brand name*'
                                    : null),
                            SizedBox(height: 8),
                            ItemDetails(controller: itemDescriptionController),
                            SizedBox(height: 8),
                            MyDate(
                              title: 'Guarantee expiry date*',
                              monthController: expiryMonthController,
                              yearController: expiryYearController,
                              yearValidator: (value) =>
                                  value.isEmpty || value.length != 4
                                      ? 'Year'
                                      : null,
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
                            // kIsWeb ?
                            // UploadImageWebWidget(
                            //   file: widget.ds['receiptImage'],
                            //   // file: widget.item.receiptImage,
                            //   onTap: () => Utils.updateImageWeb(
                            //     id: '${widget.item.id}',
                            //     docField: 'receiptImage',
                            //   ),
                            //   title: 'Upload receipt photo*',
                            // ),
                            // // : receiptPhotoFile == null
                            // //     ? ImageFromFirestoreWidget(
                            // //         onTap: () {
                            // //           selectReceiptFile();
                            // //         },
                            // //         title: 'Upload receipt photo*',
                            // //         image: widget.item.receiptImage!)
                            // //     : UploadImageMobileWidget(
                            // //         file: receiptPhotoFile,
                            // //         onTap: () {
                            // //           selectReceiptFile();
                            // //           // print('upload receipt tapped');
                            // //         },
                            // //         title: 'Upload receipt photo*',
                            // //       ),
                            // SizedBox(height: 8),
                            // // kIsWeb?
                            // UploadImageWebWidget(
                            //   // file: widget.item.itemImage!,
                            //   file: widget.ds['itemImage'],
                            //   onTap: () async {
                            //     await Utils.updateImageWeb(
                            //       id: '${widget.item.id}',
                            //       docField: 'itemImage',
                            //     );
                            //     setState(() {});
                            //   },
                            //   title: 'Upload item photo*',
                            // ),
                            // : itemPhotoFile == null
                            //     ? ImageFromFirestoreWidget(
                            //         onTap: () {
                            //           selectItemPhotoFile();
                            //         },
                            //         title: 'Upload item photo*',
                            //         image: widget.item.itemImage!)
                            //     : UploadImageMobileWidget(
                            //         file: itemPhotoFile,
                            //         onTap: () {
                            //           selectItemPhotoFile();
                            //           // print('upload item widget tapped');
                            //         },
                            //         title: 'Upload item photo*',
                            //       ),
                            // const SizedBox(height: 4.0),
                            UploadImageWebController(
                              currentDocId: widget.item.id!,
                              title: 'Upload receipt photo*',
                              docField: 'receiptImage',
                              height: 240,
                              width: 120,
                            ),
                            SizedBox(height: 15),
                            UploadImageWebController(
                              currentDocId: widget.item.id!,
                              title: 'Upload item photo*',
                              docField: 'itemImage',
                            ),
                            SizedBox(height: 15),
                            generalError == false
                                ? const SizedBox.shrink()
                                : Column(
                                    children: [
                                      const SizedBox(height: 2.0),
                                      Text(
                                        'Please fill in the fields marked *',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 14),
                                      ),
                                    ],
                                  ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  unFocus();
                                  final isValid =
                                      _formKey.currentState!.validate();
                                  if (!isValid) {
                                    // generalError = true;
                                    return;
                                  } else {
                                    setState(() => loading = true);

                                    await _firestore
                                        .collection('things')
                                        .doc(widget.item.id)
                                        .update({
                                      'itemShortDescription': null ??
                                          itemDescriptionController.text,
                                      'brandName': brandNameController.text,
                                      'expiryDate': DateTime(
                                          int.parse(expiryYearController.text),
                                          int.parse(
                                              expiryMonthController.text)),
                                      'purchaseDate': DateTime(
                                          int.parse(
                                              purchaseYearController.text),
                                          int.parse(
                                              purchaseMonthController.text)),
                                    });
                                    // context.read(detailsPageController.notifier).myItem(
                                    //       id: widget.item.id,
                                    //       brandName: brandNameController.text,
                                    //       expiryDate: DateTime(
                                    //           int.parse(expiryYearController.text),
                                    //           int.parse(expiryMonthController.text)),
                                    //       itemImage: widget.item.itemImage,
                                    //       itemShortDescription:
                                    //           null ?? itemDescriptionController.text,
                                    //       purchaseDate: DateTime(
                                    //           int.parse(purchaseYearController.text),
                                    //           int.parse(purchaseMonthController.text)),
                                    //       receiptImage: widget.item.receiptImage,
                                    //       userEmail: widget.item.userEmail,
                                    //     );
                                    // .then((value) => print('successfully edited'))
                                    // .catchError((onError) =>
                                    //     print('this is the error: $onError'));
                                    Navigator.of(context).pop();
                                    receiptImage == null
                                        ? Utils.showSnackBar(
                                            context, 'Saved to Drafts')
                                        : Utils.showSnackBar(
                                            context, 'Successfully Edited');
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  child: Text('Save Changes',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: kAppGreen),
                              ),
                            ),
                            SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // void selectReceiptFile() async {
          //   final result = await FilePicker.platform.pickFiles(allowMultiple: false);
          //   if (result == null) return;
          //   final path = result.files.single.path;
          //   setState(() => receiptPhotoFile = File(path!));
          // }
          //
          // void selectItemPhotoFile() async {
          //   final result = await FilePicker.platform.pickFiles(allowMultiple: false);
          //   if (result == null) return;
          //   final path = result.files.single.path;
          //   setState(() => itemPhotoFile = File(path!));
          // }
        });
  }
}
