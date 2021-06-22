import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/utils.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MyThingCard extends StatelessWidget {
  final DocumentSnapshot ds;

  const MyThingCard({
    Key? key,
    required this.ds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width / 3.2;

    CollectionReference things =
        FirebaseFirestore.instance.collection('things');

    final from = Utils.toDateTime(ds['purchaseDate']);
    final now = DateTime.now();
    final guaranteeEnd = Utils.toDateTime(ds['expiryDate']);
    final months = kGuaranteeTimeRemaining(from!, now, guaranteeEnd!);
    // print(months);
    return Card(
      // color: Colors.lightBlueAccent,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
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
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 30,
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
                    child: Hero(
                      tag: ds.id,
                      child: Image.network(
                        data['itemImage'],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }

                // return Text("loading");
                return Expanded(
                    child: Center(child: CircularProgressIndicator()));
              },
            ),
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
            const SizedBox(height: 8),
            Container(
              // color: Colors.blue,
              height: 40,
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
            const SizedBox(height: 20),

            // check if guarantee is expired
            now.compareTo(guaranteeEnd) > 0
                ? SizedBox(height: 6)
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
    );
  }
}
