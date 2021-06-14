// import 'package:flutter/material.dart';
// import 'package:mythings/firebase_api/firebase_api.dart';
// import 'package:mythings/models/myThings_model.dart';
//
// class MyThingsProvider extends ChangeNotifier {
//   // List<MyThing> _myThings = [
//   //   MyThing(
//   //     itemImage: 'assets/iphone.jpg',
//   //     receiptImage: 'assets/rec1.jpg',
//   //     itemShortDescription: 'Kaffeevoltautomat E80 Pianoblack cool and',
//   //     brandName: 'APPLE',
//   //     expiryDate: DateTime(2021, 12),
//   //     purchaseDate: DateTime(2020, 01),
//   //   ),
//   //   MyThing(
//   //     itemImage: 'assets/smart_tv.png',
//   //     receiptImage: 'assets/rec5.jpg',
//   //     itemShortDescription: 'LED TV 43" - TV Flat UHD',
//   //     brandName: 'SAMSUNG',
//   //     expiryDate: DateTime(2021, 9),
//   //     purchaseDate: DateTime(2020, 01),
//   //   ),
//   //   MyThing(
//   //     itemImage: 'assets/sound.jpg',
//   //     receiptImage: 'assets/rec2.jpg',
//   //     itemShortDescription: 'Bass and all the above',
//   //     brandName: 'JURA',
//   //     expiryDate: DateTime(2021, 2),
//   //     purchaseDate: DateTime(2020, 01),
//   //   ),
//   // ];
//   List<MyThing> _myThings = [];
//   List<MyThing> get myThings => _myThings;
//
//   // void addThing(MyThing myThing) {
//   //   _myThings.add(myThing);
//   //   notifyListeners();
//   // }
//
//   void addThing(MyThing myThing) => FirebaseApi.createThing(myThing);
//
//   void setMyAdverts(List<MyThing>? myThings) =>
//       WidgetsBinding.instance!.addPostFrameCallback((_) {
//         _myThings = myThings!;
//         notifyListeners();
//       });
// }
