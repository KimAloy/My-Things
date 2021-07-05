import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemRepositoryProvider =
    Provider<ItemRepository>((ref) => ItemRepository());

/// currently reloading infinitely I don't know why
// StreamProvider<DocumentSnapshot> readingItem({required String docId}) {
//   return StreamProvider<DocumentSnapshot>(
//       (ref) => ref.watch(itemRepositoryProvider).readItem(docId: docId));
// }

class ItemRepository {
  final User? loggedInUser = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot> get streamMyThings => FirebaseFirestore.instance
      .collection('things')
      .where('userEmail', isEqualTo: loggedInUser!.email)
      .snapshots();

  Stream<QuerySnapshot> get streamDrafts => FirebaseFirestore.instance
      .collection('things')
      .where('userEmail', isEqualTo: loggedInUser!.email)
      .where('receiptImage', isNull: true) // null can only be set to true
      .snapshots();

  Stream<DocumentSnapshot> readItem({required String docId}) {
    return FirebaseFirestore.instance
        .collection('things')
        .doc(docId)
        .snapshots();
  }
}
