import 'package:flutter/material.dart';

double kGuaranteeTimeRemaining(DateTime from, DateTime now, DateTime expiry) {
  from = DateTime(from.year, from.month);
  now = DateTime(now.year, now.month);
  expiry = DateTime(expiry.year, expiry.month);
  int remainingTime = (expiry.difference(now).inDays);
  int guarantee = (expiry.difference(from).inDays);
  // print('remainingTime: $remainingTime');
  // print('guarantee: $guarantee');
  return ((remainingTime / guarantee)).toDouble();
}

const kGuaranteeTextStyle = TextStyle(
  fontSize: 11.5,
  fontWeight: FontWeight.w500,
  color: Colors.black87,
);

const kAppGreen = Color(0xFF00D584);

const kGrey50 = Color(0xFFFAFAFA); // some grey 50

const kGrey100 = Color(0xFFF5F5F5); // some grey 100

const kCardTitleTextStyle = TextStyle(fontSize: 16);
