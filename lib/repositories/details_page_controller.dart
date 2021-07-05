// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mythings/models/item_model.dart';

/// Using StateNotifierProvider
// final detailsPageController =
//     StateNotifierProvider<Experiment, Item>((ref) => Experiment());
//
// class Experiment extends StateNotifier<Item> {
//   Experiment()
//       : super(Item(
//             brandName: '',
//             expiryDate: DateTime.now(),
//             purchaseDate: DateTime.now(),
//             userEmail: ''));
//
//   void myItem({
//     id,
//     brandName,
//     expiryDate,
//     itemImage,
//     itemShortDescription,
//     purchaseDate,
//     receiptImage,
//     userEmail,
//   }) {
//     state.id = id;
//     state.brandName = brandName;
//     state.expiryDate = expiryDate;
//     state.itemImage = itemImage;
//     state.itemShortDescription = itemShortDescription;
//     state.purchaseDate = purchaseDate;
//     state.receiptImage = receiptImage;
//     state.userEmail = userEmail;
//     // add this line of code to update the UI
//     state = state;
//   }
// }
//
// /// This is AsyncValue example
// // final itemListControllerProvider =
// //     StateNotifierProvider<ItemListController, AsyncValue<List<Item>>>(
// //   (ref) {
// //     final user = ref.watch(authControllerProvider);
// //     return ItemListController(ref.read, user?.uid);
// //   },
// // );
// //
// // class ItemListController extends StateNotifier<AsyncValue<List<Item>>> {
// //   final Reader _read;
// //   final String? _userId;
// //
// //   ItemListController(this._read, this._userId) : super(AsyncValue.loading()) {
// //     //  when out ItemListController is instanciated we want to call retrieveItems()
// //     if (_userId != null) {
// //       retrieveItems();
// //     }
// //   }
// //   Future<void> retrieveItems({bool isRefreshing = false}) async {
// //     if (isRefreshing) state = AsyncValue.loading();
// //     try {
// //       final items =
// //           await _read(itemRepositoryProvider).retrieveItems(docId: _userId!);
// //       if (mounted) {
// //         state = AsyncValue.data(items);
// //       }
// //       //  st is the stack trace
// //     } on CustomException catch (e, st) {
// //       state = AsyncValue.error(e, st);
// //     }
// //   }
// // }
// //
// // final itemRepositoryProvider =
// //     Provider<ItemRepository>((ref) => ItemRepository());
// //
// // class ItemRepository {
// //   Future<Item> retrieveItems({required String docId}) async {
// //     try {
// //       DocumentSnapshot ds = await FirebaseFirestore.instance
// //           .collection('things')
// //           .doc(docId)
// //           .get();
// //       return Item(
// //         id: ds.id,
// //         brandName: ds['brandName'],
// //         expiryDate: Utils.toDateTime(ds['expiryDate']),
// //         itemImage: ds['itemImage'],
// //         itemShortDescription: ds['itemShortDescription'],
// //         purchaseDate: Utils.toDateTime(ds['purchaseDate']),
// //         receiptImage: ds['receiptImage'],
// //         userEmail: ds['userEmail'],
// //       );
// //     } on FirebaseAuthException catch (e) {
// //       throw CustomException(message: e.message);
// //     }
// //   }
// // }
// //
// // /// customException widget
// // class CustomException implements Exception {
// //   final String? message;
// //
// //   CustomException({this.message = 'Something went wrong'});
// //
// //   @override
// //   String toString() => 'CustomException { message: $message}';
// // }
// //
