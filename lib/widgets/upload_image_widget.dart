import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';

class UploadImageWidget extends StatelessWidget {
  final Function onTap;
  final String title;
  final File? file;

  const UploadImageWidget({
    Key? key,
    required this.onTap,
    required this.title,
    required this.file,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(title, style: kCardTitleTextStyle),
                  Spacer(),
                  Icon(Icons.file_upload),
                ],
              ),
              // ignore: unnecessary_null_comparison
              file == null
                  ? const SizedBox.shrink()
                  : Container(
                      height: 100,
                      width: 100,
                      child: Image.file(file!),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
