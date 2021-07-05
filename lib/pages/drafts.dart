import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mythings/models/item_model.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/repositories/item_repository.dart';
import 'package:mythings/my_constants/responsive.dart';
import 'package:mythings/widgets/myThing_card.dart';
import 'package:mythings/widgets/my_drawer.dart';
import 'package:mythings/widgets/my_menu_button.dart';
import 'package:mythings/widgets/profile_picture.dart';

import '../repositories/utils.dart';
import 'edit_myThing_page.dart';

final draftsStreamProvider = StreamProvider<QuerySnapshot>(
    (ref) => ref.watch(itemRepositoryProvider).streamDrafts);

class DraftsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    Future<void> refresh() {
      return Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => DraftsPage()));
    }

    final draftProvider = watch(draftsStreamProvider);
    return draftProvider.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('OOps!'),
      data: (val) {
        int draftsLength = val.docs.length;
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
                                draftsLength == 1
                                    ? '1 Draft'
                                    : '$draftsLength Drafts',
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
                            .map((DocumentSnapshot ds) {
                          Item item = Item.fromJson(ds: ds);
                          return GestureDetector(
                            onLongPress: () => Utils.deleteThing(ds: ds),
                            child: MyThingCard(
                              // ds: ds,
                              item: item,
                              onTap: () {
                                // TODO: replace beamer package for navigation
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditPage(item: item)),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
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
