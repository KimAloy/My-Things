import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mythings/models/item_model.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/my_constants/responsive.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MyThingCard extends StatelessWidget {
  // final DocumentSnapshot ds;
  final Function onTap;
  final Item item;

  const MyThingCard({
    Key? key,
    // required this.ds,
    required this.onTap,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final from = item.purchaseDate;
    // final from = Utils.toDateTime(ds['purchaseDate']);
    final now = DateTime.now();
    // final guaranteeEnd = Utils.toDateTime(ds['expiryDate']);
    final guaranteeEnd = item.expiryDate;
    final months = kGuaranteeTimeRemaining(from, now, guaranteeEnd);
    // print(months);
    return GestureDetector(
        onTap: onTap as void Function()?,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Card(
            child: Container(
              height: 190,
              width: Responsive.isMobile(context) ? 150 : 160,
              child: Column(
                // default crossAxisAlignment is center
                children: [
                  const SizedBox(height: 10),
                  // _ItemImage(id: ds.id),
                  Container(
                    // color: Colors.red,
                    height: 50,
                    width: 90,
                    child: Hero(
                      tag: item.id!,
                      child: item.itemImage == null
                          ? Center(child: Text('No image'))
                          : Image.network(
                              '${item.itemImage}',
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    // ds['brandName'],
                    item.brandName,
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
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      item.itemShortDescription == null
                          ? ''
                          : item.itemShortDescription!,
                      // ds['itemShortDescription'] == null
                      //     ? ''
                      //     : ds['itemShortDescription'],
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
                            // width: cardWidth * 1.43,
                            width: Responsive.isMobile(context) ? 150 : 160,
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
          ),
        ));
  }
}
