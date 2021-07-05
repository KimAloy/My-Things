import 'package:cloud_firestore/cloud_firestore.dart';

import '../repositories/utils.dart';

class Item {
  String? id;
  String brandName;
  DateTime expiryDate;
  String? itemImage;
  String? itemShortDescription;
  DateTime purchaseDate;
  String? receiptImage;
  String userEmail;

  Item({
    this.id,
    required this.brandName,
    required this.expiryDate,
    this.itemImage,
    this.itemShortDescription,
    required this.purchaseDate,
    this.receiptImage,
    required this.userEmail,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'brandName': brandName,
        'expiryDate': Utils.fromDateTimeToJson(expiryDate),
        'itemImage': itemImage,
        'itemShortDescription': itemShortDescription,
        'purchaseDate': Utils.fromDateTimeToJson(purchaseDate),
        'receiptImage': receiptImage,
        'userEmail': userEmail,
      };

  static Item fromJson({required DocumentSnapshot ds}) => Item(
        id: ds.id,
        brandName: ds['brandName'],
        expiryDate: Utils.toDateTime(ds['expiryDate']),
        itemImage: ds['itemImage'],
        itemShortDescription: ds['itemShortDescription'],
        purchaseDate: Utils.toDateTime(ds['purchaseDate']),
        receiptImage: ds['receiptImage'],
        userEmail: ds['userEmail'],
      );
}
