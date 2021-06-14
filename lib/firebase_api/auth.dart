import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mythings/models/user_model.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map((User? user) => (user != null)
        ? UserModel(
            uid: user.uid,
          )
        : null);
  }

  Future<void> signOutUser() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  UserModel _userDataModelFromSnapshot(DocumentSnapshot snapshot) {
    final User currentUser = _auth.currentUser!;
    final uid = currentUser.uid;
    return UserModel(
      uid: uid,
      email: snapshot['email'],
      name: snapshot['name'],
      profilePicture: snapshot['profilePicture'],
    );
  }

  Stream<UserModel> get userData {
    final User currentUser = _auth.currentUser!;
    final uid = currentUser.uid;

    return usersCollection.doc(uid).snapshots().map(_userDataModelFromSnapshot);
  }

  // // delete user firestore data
  // Future<void> deleteUserFirestoreData() {
  //   final User? currentUser = _auth.currentUser;
  //   return usersCollection
  //       .doc(currentUser!.uid)
  //       .delete()
  //       .then((value) => print("User Deleted"))
  //       .catchError((error) => print("Failed to delete user: $error"));
  // }

  // Delete account
  Future deleteAccount() async {
    User user = _auth.currentUser!;
    user.delete();
  }
}
