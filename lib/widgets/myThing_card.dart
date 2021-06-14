import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/utils.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MyThingCard extends StatelessWidget {
  final DocumentSnapshot ds;
  final double cardWidth;

  const MyThingCard({
    Key? key,
    required this.ds,
    required this.cardWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference things =
        FirebaseFirestore.instance.collection('things');

    final from = Utils.toDateTime(ds['purchaseDate']);
    final now = DateTime.now();
    final guaranteeEnd = Utils.toDateTime(ds['expiryDate']);
    final months = kGuaranteeTimeRemaining(from!, now, guaranteeEnd!);
    // print(months);
    return Card(
      // color: Colors.lightBlueAccent,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 8,
            right: 8,
            child: Column(
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: things.doc(ds.id).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Container(
                        height: 50,
                        width: 90,
                        // color: Colors.grey.shade200,

                        child: Center(
                          child: Icon(
                            Icons.image_search_outlined,
                            // color: Colors.white70,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      );
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Container(
                        // color: Colors.red,
                        height: 50,
                        width: 90,
                        // child: Image.asset(myThing.itemImage!),
                        child: Hero(
                          tag: ds.id,
                          // tag: ds['itemImage'],
                          child: Image.network(
                            data['itemImage'],
                            // ds['itemImage'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }

                    // return Text("loading");
                    return Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  },
                ),
                // Container(
                //   // color: Colors.red,
                //   height: 50,
                //   width: 90,
                //   // child: Image.asset(myThing.itemImage!),
                //   child: Hero(
                //     tag: ds.id,
                //     // tag: ds['itemImage'],
                //     child: Image.network(
                //       ds['itemImage'],
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                SizedBox(height: 8),
                Text(
                  ds['brandName'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 90,
            left: 8,
            right: 8,
            child: Text(
              ds['itemShortDescription'] == null
                  ? ''
                  : ds['itemShortDescription'],
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 1,
            right: 1,
            child: Column(
              children: [
                // check if guarantee is expired
                now.compareTo(guaranteeEnd) > 0
                    ? SizedBox.shrink()
                    : RotatedBox(
                        quarterTurns: 2,
                        child: LinearPercentIndicator(
                          alignment: MainAxisAlignment.end,
                          width: cardWidth * 1.43,
                          lineHeight: 6,
                          percent: months,
                          progressColor: kAppGreen,
                        ),
                      ),
                SizedBox(height: 6),
                // check if guarantee is expired
                now.compareTo(guaranteeEnd) > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Center(
                          child: Text(
                            'Guarantee expired',
                            style: kGuaranteeTextStyle,
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        // color: Colors.blueGrey,
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Guarantee till',
                              style: kGuaranteeTextStyle,
                              textAlign: TextAlign.start,
                            ),
                            Expanded(
                              child: Text(
                                '${guaranteeEnd.month}/${guaranteeEnd.year}',
                                style: kGuaranteeTextStyle,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
