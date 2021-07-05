import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mythings/models/item_model.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/pages/add_thing_mobile_page.dart';
import 'package:mythings/pages/add_thing_web_page_1.dart';
import 'package:mythings/repositories/item_repository.dart';
import 'package:mythings/my_constants/responsive.dart';
import 'package:mythings/widgets/myThing_card.dart';
import 'package:mythings/widgets/my_drawer.dart';
import 'package:mythings/widgets/my_menu_button.dart';
import 'package:mythings/widgets/profile_picture.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'myThing_details_page.dart';

final myThingsStreamProvider = StreamProvider<QuerySnapshot>(
    (ref) => ref.watch(itemRepositoryProvider).streamMyThings);

class MyThingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    Future<void> refresh() {
      return Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyThingsPage()));
    }

    final thingsProvider = watch(myThingsStreamProvider);
    return thingsProvider.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('OOps!'),
      data: (val) {
        int myThingsLength =
            val.docs.where((element) => element['receiptImage'] != null).length;
        return Container(
          color: kGrey50,
          child: Center(
            child: Container(
              width: Responsive.isMobile(context) ? double.infinity : 600,
              child: RefreshIndicator(
                onRefresh: refresh,
                color: kAppGreen,
                child: Scaffold(
                  backgroundColor: kGrey100,
                  drawer: MyDrawer(),
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
                                  MyMenuButton(),
                                  Spacer(),
                                  ProfilePicture(),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
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
                    child: Center(
                      child: Wrap(
                        children: val.docs
                            // this is a filter
                            .where((element) => element['receiptImage'] != null)
                            .map((DocumentSnapshot ds) {
                          Item item = Item.fromJson(ds: ds);
                          return MyThingCard(
                            // ds: ds,
                            item: item,
                            onTap: () {
                              // TODO: replace beamer package for navigation
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MyThingDetailPage(ds: ds, item: item)));
                              // context
                              //     .read(detailsPageController.notifier)
                              //     .myItem(
                              //       id: item.id,
                              //       brandName: item.brandName,
                              //       expiryDate: item.expiryDate,
                              //       itemImage: item.itemImage,
                              //       itemShortDescription:
                              //           item.itemShortDescription,
                              //       purchaseDate: item.purchaseDate,
                              //       receiptImage: item.receiptImage,
                              //       userEmail: item.userEmail,
                              //     );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        // return kIsWeb ?
                        return AddThingWebPage1();
                        // : AddThingMobilePage();
                      }));
                    },
                    tooltip: 'Add Thing',
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
