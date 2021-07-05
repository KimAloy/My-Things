import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mythings/models/item_model.dart';
import 'package:mythings/my_constants/my_constants.dart';
import 'package:mythings/pages/edit_myThing_page.dart';
import 'package:mythings/pages/myThings_page.dart';
import 'package:mythings/my_constants/responsive.dart';
import 'package:mythings/widgets/my_dialog.dart';
import 'package:mythings/widgets/details_page_images.dart';
import 'dart:html' as html;
import '../repositories/utils.dart';

class MyThingDetailPage extends StatefulWidget {
  final DocumentSnapshot ds;
  final Item item;

  const MyThingDetailPage({
    Key? key,
    required this.ds,
    required this.item,
  }) : super(key: key);

  @override
  _MyThingDetailPageState createState() => _MyThingDetailPageState();
}

class _MyThingDetailPageState extends State<MyThingDetailPage> {
  String? percentageProgress;
  double? progress;

  bool _isDownloading = false;

  Future<void> refresh() {
    return Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  openInANewTab({required String url}) {
    /// this is a temporary fix for downloading, it opens image in new website where user can right click to download
    html.window.open(url, 'long_press_to_download');
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          actions: [
            Responsive.isMobile(context)
                ? PopupMenuButton<int>(
                    onSelected: (item) => onSelected(context, item),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 4),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      //TODO: I'm commenting with out because it's not available on web
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.download_sharp),
                            SizedBox(width: 4),
                            Text('Download'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.delete_outlined),
                            SizedBox(width: 4),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _DetailsPageButton(
                        onPressed: edit,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      const SizedBox(width: 12),
                      _DetailsPageButton(
                        onPressed:
                            openInANewTab(url: widget.item.receiptImage!),

                        // kIsWeb ? downloadImageWeb : downloadImageMobile,
                        icon: Icons.download_sharp,
                        label: 'Download',
                      ),
                      const SizedBox(width: 12),
                      _DetailsPageButton(
                        onPressed: delete,
                        icon: Icons.delete_outlined,
                        label: 'Delete',
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            // color: Colors.yellow,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(height: 20),
                !_isDownloading
                    ? SizedBox.shrink()
                    : LinearProgressIndicator(
                        value: progress,
                        valueColor: AlwaysStoppedAnimation(kAppGreen),
                        // minHeight: 10,
                        backgroundColor: Colors.white,
                      ),
                MyItemOnDetailsPage(ds: widget.ds),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        edit();
        break;
      case 1:
        // download();
        openInANewTab(url: widget.item.receiptImage!);
        // kIsWeb ? downloadImageWeb() : downloadImageMobile();
        //   downloadImageWeb();
        // FileService.fileDownload(
        //     baseUrl: '${widget.item.receiptImage}', fileName: 'myThing.png');
        break;
      case 2:
        delete();
        break;
    }
  }

  void edit() {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return EditPage(
          // ds: widget.ds,
          item: widget.item);
    }));
  }

  void delete() {
    showDialog(
        context: context,
        builder: (context) {
          return MyDialog(
            title: 'Permanently delete this thing?',
            onPressed: () {
              Utils.deleteThing(ds: widget.ds);
              // Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MyThingsPage()),
                  (Route<dynamic> route) => false);
            },
          );
        });
  }
}

class _DetailsPageButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String label;

  const _DetailsPageButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed as void Function()?,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        primary: Colors.black,
        onSurface: Colors.black,
      ),
    );
  }
}

// class MyThingDetailPage extends ConsumerWidget {
//   final DocumentSnapshot ds;
//
//   MyThingDetailPage({required this.ds});
//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     void delete() {
//       showDialog(
//           context: context,
//           builder: (context) {
//             return MyDialog(
//               title: 'Permanently delete this thing?',
//               onPressed: () {
//                 Utils.deleteThing(ds: ds);
//                 // Navigator.of(context).pop();
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (context) => MyThingsPage()),
//                     (Route<dynamic> route) => false);
//               },
//             );
//           });
//     }
//
//     // bool _isDownloading = false;
//     Future<void> refresh() {
//       return Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) => MyThingDetailPage(
//                     ds: ds,
//                   )));
//     }
//
//     Item item = watch(detailsPageController);
//     return RefreshIndicator(
//       onRefresh: refresh,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           iconTheme: IconThemeData(color: Colors.black),
//           elevation: 0.0,
//           actions: [
//             Responsive.isMobile(context)
//                 ? PopupMenuButton<int>(
//                     onSelected: (selected) {
//                       switch (selected) {
//                         case 0:
//                           // edit();
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (_) {
//                             return EditPage(item: item, ds: ds);
//                           }));
//
//                           break;
//                         // case 1:
//                         // kIsWeb ? downloadImageWeb() : downloadImageMobile();
//                         //   downloadImageWeb();
//                         //   break;
//                         case 2:
//                           delete();
//                           break;
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       PopupMenuItem(
//                         value: 0,
//                         child: Row(
//                           children: [
//                             Icon(Icons.edit),
//                             SizedBox(width: 4),
//                             Text('Edit'),
//                           ],
//                         ),
//                       ),
//                       // //TODO: I'm commenting with out because it's not available on web
//                       // PopupMenuItem(
//                       //   value: 1,
//                       //   child: Row(
//                       //     children: [
//                       //       Icon(Icons.download_sharp),
//                       //       SizedBox(width: 4),
//                       //       Text('Download'),
//                       //     ],
//                       //   ),
//                       // ),
//                       PopupMenuItem(
//                         value: 2,
//                         child: Row(
//                           children: [
//                             Icon(Icons.delete_outlined),
//                             SizedBox(width: 4),
//                             Text('Delete'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )
//                 : Row(
//                     children: [
//                       _DetailsPageButton(
//                         onPressed: () {
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (_) {
//                             return EditPage(item: item, ds: ds);
//                           }));
//                         },
//                         icon: Icons.edit,
//                         label: 'Edit',
//                       ),
//                       // const SizedBox(width: 12),
//                       // DetailsPageButton(
//                       //   onPressed:
//                       //       kIsWeb ? downloadImageWeb : downloadImageMobile,
//                       //   icon: Icons.download_sharp,
//                       //   label: 'Download',
//                       // ),
//                       const SizedBox(width: 12),
//                       _DetailsPageButton(
//                         onPressed: delete,
//                         icon: Icons.delete_outlined,
//                         label: 'Delete',
//                       ),
//                       const SizedBox(width: 15),
//                     ],
//                   ),
//           ],
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // SizedBox(height: 20),
//             // !_isDownloading
//             //     ? SizedBox.shrink()
//             //     : LinearProgressIndicator(
//             //   value: progress,
//             //   valueColor: AlwaysStoppedAnimation(kAppGreen),
//             //   // minHeight: 10,
//             //   backgroundColor: Colors.white,
//             // ),
//             Center(
//               child: Container(
//                 // color: Colors.red,
//                 height: 120,
//                 width: 240,
//                 child: Hero(
//                   tag: item.id!,
//                   child: Image.network(
//                     item.itemImage!,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Center(
//                 child: Text(
//                   item.brandName,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.black54,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Center(
//                 child: Text(
//                   item.itemShortDescription!,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.black87,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 8),
//             ReceiptImageDetailsPage(ds: widget.ds),
//             // Expanded(
//             //   child: Container(
//             //     child: PhotoView(
//             //       backgroundDecoration: BoxDecoration(color: Colors.white),
//             //       imageProvider: NetworkImage(item.receiptImage!),
//             //     ),
//             //   ),
//             // ),
//             SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
