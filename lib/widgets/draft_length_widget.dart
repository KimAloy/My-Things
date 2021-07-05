import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mythings/pages/drafts.dart';

class DraftLengthWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final draft = watch(draftsStreamProvider);

    return draft.when(
        data: (val) {
          int draftsLength = val.docs.length;
          return draftsLength == 0
              ? Container()
              : Container(
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        draftsLength.toString(),
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    ),
                  ),
                );
        },
        loading: () => Container(),
        error: (error, stack) => Text('Oops!'));
  }
}
