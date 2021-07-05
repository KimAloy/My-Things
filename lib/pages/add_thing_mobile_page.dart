// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:loading_overlay/loading_overlay.dart';
// import 'package:mythings/my_constants/my_constants.dart';
// import 'package:mythings/repositories/firebase_api.dart';
// import 'package:mythings/widgets/brand_name.dart';
// import 'package:mythings/widgets/itemDetails.dart';
// import 'package:mythings/widgets/my_date.dart';
// import 'package:mythings/widgets/upload_image_widget.dart';
//
// class AddThingMobilePage extends StatefulWidget {
//   const AddThingMobilePage({Key? key}) : super(key: key);
//
//   @override
//   _AddThingMobilePageState createState() => _AddThingMobilePageState();
// }
//
// class _AddThingMobilePageState extends State<AddThingMobilePage> {
//   final itemDescriptionController = TextEditingController();
//   final brandNameController = TextEditingController();
//   final expiryMonthController = TextEditingController();
//   final expiryYearController = TextEditingController();
//   final purchaseMonthController = TextEditingController();
//   final purchaseYearController = TextEditingController();
//
//   File? receiptPhotoFile;
//   File? itemPhotoFile;
//   bool loading = false;
//   bool itemPhotoError = false;
//   bool receiptPhotoError = false;
//   bool generalError = false;
//
//   var currentFocus;
//
//   void unFocus() {
//     currentFocus = FocusScope.of(context);
//
//     if (!currentFocus.hasPrimaryFocus) {
//       currentFocus.unfocus();
//     }
//   }
//
//   final _formKey = GlobalKey<FormState>();
//   final _firestore = FirebaseFirestore.instance;
//   final User? loggedInUser = FirebaseAuth.instance.currentUser;
//   final currentDate = DateTime.now();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: kAppGreen,
//         title: Text('Add Thing'),
//         elevation: 0,
//       ),
//       body: LoadingOverlay(
//         isLoading: loading,
//         opacity: 0.3,
//         progressIndicator: CircularProgressIndicator(),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 BrandName(
//                     controller: brandNameController,
//                     validator: (text) =>
//                         text.isEmpty ? 'Please enter a Brand name*' : null),
//                 SizedBox(height: 8),
//                 ItemDetails(controller: itemDescriptionController),
//                 SizedBox(height: 8),
//                 MyDate(
//                   title: 'Guarantee expiry date*',
//                   monthController: expiryMonthController,
//                   yearController: expiryYearController,
//                   yearValidator: (value) =>
//                       value.isEmpty || value.length != 4 ? 'Year' : null,
//                 ),
//                 SizedBox(height: 8),
//                 MyDate(
//                   title: 'Purchase date*',
//                   monthController: purchaseMonthController,
//                   yearController: purchaseYearController,
//                   yearValidator: (value) => value.isEmpty ||
//                           int.parse(value) > currentDate.year ||
//                           value.length != 4
//                       ? 'Year'
//                       : null,
//                 ),
//                 SizedBox(height: 8),
//                 UploadImageMobileWidget(
//                   file: receiptPhotoFile,
//                   onTap: () {
//                     selectReceiptFile();
//                     // print('upload receipt tapped');
//                   },
//                   title: 'Upload receipt photo*',
//                 ),
//                 receiptPhotoError == false
//                     ? const SizedBox.shrink()
//                     : Column(
//                         children: [
//                           const SizedBox(height: 2.0),
//                           Text(
//                             'Select a receipt photo',
//                             style: TextStyle(color: Colors.red, fontSize: 14),
//                           ),
//                         ],
//                       ),
//                 SizedBox(height: 8),
//                 UploadImageMobileWidget(
//                   file: itemPhotoFile,
//                   onTap: () {
//                     selectItemPhotoFile();
//                     // print('upload item widget tapped');
//                   },
//                   title: 'Upload item photo*',
//                 ),
//                 const SizedBox(height: 4.0),
//                 itemPhotoError == false
//                     ? const SizedBox.shrink()
//                     : Column(
//                         children: [
//                           const SizedBox(height: 2.0),
//                           Text(
//                             'Select an item photo',
//                             style: TextStyle(color: Colors.red, fontSize: 14),
//                           ),
//                         ],
//                       ),
//                 SizedBox(height: 15),
//                 generalError == false
//                     ? const SizedBox.shrink()
//                     : Column(
//                         children: [
//                           const SizedBox(height: 2.0),
//                           Text(
//                             'Please fill in the fields marked *',
//                             style: TextStyle(color: Colors.red, fontSize: 14),
//                           ),
//                         ],
//                       ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: ElevatedButton(
//                     onPressed: addThing,
//                     child: Text('Add Thing'),
//                     style: ElevatedButton.styleFrom(primary: kAppGreen),
//                   ),
//                 ),
//                 SizedBox(height: 80),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void selectReceiptFile() async {
//     final result = await FilePicker.platform.pickFiles(allowMultiple: false);
//     if (result == null) return;
//     final path = result.files.single.path;
//     setState(() => receiptPhotoFile = File(path!));
//   }
//
//   void selectItemPhotoFile() async {
//     final result = await FilePicker.platform.pickFiles(allowMultiple: false);
//     if (result == null) return;
//     final path = result.files.single.path;
//     setState(() => itemPhotoFile = File(path!));
//   }
//
//   void addThing() async {
//     unFocus();
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     final User? currentUser = _auth.currentUser;
//     final isValid = _formKey.currentState!.validate();
//     if (!isValid) {
//       setState(() => generalError = true);
//       return;
//     } else if (receiptPhotoFile == null) {
//       setState(() {
//         receiptPhotoError = true;
//         loading = false;
//       });
//       return;
//     } else if (itemPhotoFile == null) {
//       setState(() {
//         itemPhotoError = true;
//         loading = false;
//       });
//       return;
//     } else {
//       setState(() => loading = true);
//       UploadTask? task;
//
//       /// upload itemPhotoFile to Firebase Storage
//       if (itemPhotoFile == null) return;
//       // final fileName = itemPhotoFile!.path;
//       final destination = '${currentUser!.email}/${DateTime.now().toString()}';
//       task = FirebaseApi.uploadFile(destination, itemPhotoFile!);
//
//       print('itemPhotoFile successfully uploaded');
//
//       // Get image url
//       if (task == null) return;
//       final snapshot = await task.whenComplete(() {});
//       final itemPhotoFileUrlDownload = await snapshot.ref.getDownloadURL();
//
//       /// upload receiptPhotoFile to Firebase Storage
//       if (receiptPhotoFile == null) return;
//       // final fileName = itemPhotoFile!.path;
//       final imageDestination =
//           '${currentUser.email}/${DateTime.now().toString()}';
//       task = FirebaseApi.uploadFile(imageDestination, receiptPhotoFile!);
//
//       print('receiptPhotoFile successfully uploaded');
//
//       // Get image url
//       if (task == null) return;
//       final receiptSnapshot = await task.whenComplete(() {});
//       final receiptPhotoFileUrlDownload =
//           await receiptSnapshot.ref.getDownloadURL();
//
//       _firestore.collection('things').add({
//         'userEmail': loggedInUser!.email,
//         'itemImage': itemPhotoFileUrlDownload,
//         'receiptImage': receiptPhotoFileUrlDownload,
//         "itemShortDescription": null ?? itemDescriptionController.text,
//         'brandName': brandNameController.text,
//         'expiryDate': DateTime(int.parse(expiryYearController.text),
//             int.parse(expiryMonthController.text)),
//         'purchaseDate': DateTime(int.parse(purchaseYearController.text),
//             int.parse(purchaseMonthController.text)),
//       });
//
//       Navigator.of(context).pop();
//       // context.beamBack();
//     }
//   }
// }
