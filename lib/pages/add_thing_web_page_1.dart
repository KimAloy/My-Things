import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/pages/add_thing_web_page_2.dart';
import 'package:mythings/my_constants/responsive.dart';
import 'package:mythings/widgets/brand_name.dart';
import 'package:mythings/widgets/itemDetails.dart';
import 'package:mythings/widgets/my_date.dart';

class AddThingWebPage1 extends StatefulWidget {
  const AddThingWebPage1({Key? key}) : super(key: key);

  @override
  _AddThingWebPage1State createState() => _AddThingWebPage1State();
}

class _AddThingWebPage1State extends State<AddThingWebPage1> {
  final _firestore = FirebaseFirestore.instance;
  final User? loggedInUser = FirebaseAuth.instance.currentUser;

  final itemDescriptionController = TextEditingController();
  final brandNameController = TextEditingController();
  final expiryMonthController = TextEditingController();
  final expiryYearController = TextEditingController();
  final purchaseMonthController = TextEditingController();
  final purchaseYearController = TextEditingController();

  bool loading = false;
  bool itemPhotoError = false;
  bool receiptPhotoError = false;
  bool generalError = false;

  var currentFocus;

  void unFocus() {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  final _formKey = GlobalKey<FormState>();
  final currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kAppGreen,
        title: Row(
          children: [
            Text('Add Thing'),
            Spacer(),
            Text('1'),
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
              width: Responsive.isMobile(context) ? double.infinity : 600,
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
                    const SizedBox(height: 4.0),
                    itemPhotoError == false
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              const SizedBox(height: 2.0),
                              Text(
                                'Select an item photo',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ],
                          ),
                    SizedBox(height: 15),
                    generalError == false
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              const SizedBox(height: 2.0),
                              Text(
                                'Please fill in the fields marked *',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ],
                          ),
                    Row(
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              unFocus();
                              final isValid = _formKey.currentState!.validate();
                              if (!isValid) {
                                setState(() => generalError = true);
                                return;
                              } else {
                                setState(() => loading = true);

                                final result =
                                    await _firestore.collection('things').add({
                                  'userEmail': loggedInUser!.email,
                                  'itemImage': null,
                                  'receiptImage': null,
                                  "itemShortDescription":
                                      null ?? itemDescriptionController.text,
                                  'brandName': brandNameController.text,
                                  'expiryDate': DateTime(
                                      int.parse(expiryYearController.text),
                                      int.parse(expiryMonthController.text)),
                                  'purchaseDate': DateTime(
                                      int.parse(purchaseYearController.text),
                                      int.parse(purchaseMonthController.text)),
                                });

                                String _documentId = result.id;

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return AddThingWebPage2(
                                      currentDocId: _documentId);
                                }));
                                setState(() => loading = false);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child:
                                  Text('Next', style: TextStyle(fontSize: 16)),
                            ),
                            style: ElevatedButton.styleFrom(primary: kAppGreen),
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
      ),
    );
  }
}
