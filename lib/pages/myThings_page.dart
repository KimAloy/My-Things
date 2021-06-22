import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mythings/firebase_api/auth.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/pages/add_thing_page.dart';
import 'package:mythings/pages/myThing_details_page.dart';
import 'package:mythings/utils.dart';
import 'package:mythings/widgets/get_user_name.dart';
import 'package:mythings/widgets/myThing_card.dart';
import 'package:mythings/widgets/my_dialog.dart';
import 'package:mythings/widgets/profile_picture.dart';

class MyThingsPage extends StatefulWidget {
  @override
  _MyThingsPageState createState() => _MyThingsPageState();
}

class _MyThingsPageState extends State<MyThingsPage> {
  @override
  Widget build(BuildContext context) {
    final _auth = Auth();

    // double cardHeight = MediaQuery.of(context).size.height / 4.7;
    final User? loggedInUser = FirebaseAuth.instance.currentUser;
    final Stream<QuerySnapshot> _myThingsStream = FirebaseFirestore.instance
        .collection('things')
        .where('userEmail', isEqualTo: loggedInUser!.email)
        .snapshots();

    Future<Stream> getData() async {
      return FirebaseFirestore.instance
          .collection('things')
          .where('userEmail', isEqualTo: loggedInUser.email)
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
        stream: _myThingsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return buildText('Something Went Wrong Try later');
          }
          // this refreshes infinitely, only use for DocumentSnapshot,
          // that's why I've used snapshot.hasData
          // if(snapshot.connectionState == ConnectionState.waiting){
          if (!snapshot.hasData) {
            // return buildText('Loading...');
            return Scaffold(
              body: Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
            // return HasNoData();
          } else {
            int myThingsLength = snapshot.data!.docs.length;
            return RefreshIndicator(
              onRefresh: getData,
              color: kAppGreen,
              child: Scaffold(
                backgroundColor: kGrey100,

                drawer: Drawer(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 65,
                        child: DrawerHeader(child: GetUserName()), //user name
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Log out'),
                        onTap: Auth().signOutUser,
                      ),
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete account'),
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return MyDialog(
                                  title:
                                      'Do you want to permanently delete your account?',
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await _auth.deleteAccount();
                                    Utils.showSnackBar(context,
                                        'Account deleted successfully');
                                  },
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(95),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: kGrey100,
                    elevation: 0.0,
                    flexibleSpace: SafeArea(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                Builder(
                                  builder: (context) => IconButton(
                                      icon: Icon(Icons.menu),
                                      onPressed: () =>
                                          Scaffold.of(context).openDrawer()),
                                ),
                                Spacer(),
                                ProfilePicture(),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Center(
                            child: Text(
                              // 'My $myThingsLength Things',
                              myThingsLength == 1
                                  ? 'My 1 Thing'
                                  : 'My $myThingsLength Things',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: myThingsLength,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot ds =
                                snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                // TODO: replace beamer package for navigation
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        MyThingDetailPage(ds: ds)));
                              },
                              child: MyThingCard(
                                ds: ds,
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            // childAspectRatio: cardWidth / cardHeight,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    // TODO: Implement better page transition to show off
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return AddThing();
                    }));
                  },
                  tooltip: 'Increment',
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ), // This trailing comma makes auto-formatting nicer for build methods.
              ),
            );
          }
        });
  }
}

Widget buildText(String text) => Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
