class MyThing {
  String? itemImage;
  String? receiptImage;
  String? itemShortDescription;
  String? brandName;
  DateTime? expiryDate;
  DateTime? purchaseDate;
  String? userEmail;

  MyThing({
    this.itemImage,
    this.receiptImage,
    this.itemShortDescription,
    this.brandName,
    this.expiryDate,
    this.purchaseDate,
    this.userEmail,
  });

  // static MyThing fromJson(DocumentSnapshot json) => MyThing(
  //       userEmail: json['userEmail'],
  //       itemImage: json['itemImage'],
  //       receiptImage: json['receiptImage'],
  //       itemShortDescription: json['itemName'],
  //       brandName: json['type'],
  //       expiryDate: Utils.toDateTime(json['expiryDate']),
  //       purchaseDate: Utils.toDateTime(json['purchaseDate']),
  //     );

  // Map<String, dynamic> toJson() => {
  //       'userEmail': userEmail,
  //       'itemImage': itemImage,
  //       'receiptImage': receiptImage,
  //       'itemName': itemShortDescription,
  //       'type': brandName,
  //       'expiryDate': Utils.fromDateTimeToJson(expiryDate),
  //       'purchaseDate': Utils.fromDateTimeToJson(purchaseDate),
  //     };
}
