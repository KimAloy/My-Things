import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';

class Utils {
  static void showSnackBar(BuildContext context, String text) =>
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: kAppGreen,
            content: Text(text),
          ),
        );

  static DateTime? toDateTime(Timestamp? value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime? date) {
    if (date == null) return null;

    return date.toUtc();
  }
}
