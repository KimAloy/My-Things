//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
//
// class ReceiptImageDetailsPage extends StatelessWidget {
//   final DocumentSnapshot ds;
//
//   const ReceiptImageDetailsPage({Key? key, required this.ds}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     CollectionReference things =
//     FirebaseFirestore.instance.collection('things');
//
//     return FutureBuilder<DocumentSnapshot>(
//       future: things.doc(ds.id).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text("Something went wrong");
//         }
//
//         if (snapshot.hasData && !snapshot.data!.exists) {
//           return Text("Document does not exist");
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting)
//           return Expanded(child: Center(child: CircularProgressIndicator()));
//
//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data =
//           snapshot.data!.data() as Map<String, dynamic>;
//           return Expanded(
//             child: Container(
//               // color: Colors.blue,
//               // child: Image.network(widget.ds['receiptImage']),
//               child: PhotoView(
//                 backgroundDecoration: BoxDecoration(color: Colors.white),
//                 imageProvider: NetworkImage(data['receiptImage']),
//               ),
//             ),
//           );
//         }
//
//         // return Text("loading");
//         return Expanded(child: Center(child: CircularProgressIndicator()));
//       },
//     );
//   }
// }
