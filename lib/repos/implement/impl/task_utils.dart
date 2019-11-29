import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:travelspots/custom_packages/worker/worker.dart';

/// Using [worker] to run this [task].
Future<T> handleWorkerTask<T>({
  @required Worker worker,
  @required Task task,
}) async {
  assert(worker != null);
  assert(task != null);
  Completer<T> completer = Completer();
  worker.handle(task).then((result) {
    completer.complete(result);
  }).catchError((e) {
    completer.completeError(e);
  });
  return completer.future;
}
