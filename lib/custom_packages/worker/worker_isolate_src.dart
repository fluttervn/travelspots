part of worker.core;

/// Map upload task
Map<String, FileTask> mapUploadTask = {};

/// Map download task
Map<String, FileTask> mapDownloadTask = {};
void _workerMain(SendPort sendPort) {
  ReceivePort receivePort;
  receivePort ??= ReceivePort();

  if (sendPort is SendPort) {
    sendPort = sendPort;
    Fimber.d('Worker: sendPort send=${receivePort.sendPort}');
    sendPort.send(receivePort.sendPort);
  }

  receivePort.listen((dynamic message) {
    if (!_acceptMessage(sendPort, receivePort, message)) return;

    try {
      if (message is Task) {
        var taskId = '';
        Fimber.d('Worker: execute Task message=$message');

        if (message is FileTask) {
          if (message.actionType == ActionType.upload) {
            taskId = message.taskId;
            mapUploadTask[taskId] = message;

            sendPort.send(taskId);
            message.taskProgressCallback = (count, total) {
              sendPort.send(_WorkerProgress(
                count: count,
                total: total,
                taskId: message.taskId,
              ));
            };
          } else if (message.actionType == ActionType.download) {
            taskId = message.taskId;
            mapDownloadTask[taskId] = message;
            sendPort.send(taskId);
            message.taskProgressCallback = (count, total) {
              sendPort.send(_WorkerProgress(
                count: count,
                total: total,
                taskId: message.taskId,
              ));
            };
          } else if (message.actionType == ActionType.cancelUpload) {
            Fimber.d('... CancelUploadTask message=$message');
            mapUploadTask.forEach((taskId, uploadTask) {
              if (taskId == message.taskId) {
                uploadTask.handleCancel(taskId);
              }
            });

            return;
          } else if (message.actionType == ActionType.cancelDownload) {
            Fimber.d('... CancelDownloadTask message=$message');
            mapDownloadTask.forEach((taskId, downloadTask) {
              if (taskId == message.taskId) {
                downloadTask.handleCancel(taskId);
              }
            });

            return;
          }
        }

        dynamic result = message.execute();
//        Function callback = mapTaskCallback[taskId];
//        if (callback != null) {}

        if (result is Future) {
          result.then(
            (dynamic futureResult) {
              Fimber.d(
                  'Worker: main: ------ WorkerResult: ${result.runtimeType}'
                  ': result=$futureResult');
              sendPort.send(_WorkerResult(futureResult, taskId: taskId));
            },
            onError: (dynamic exception, StackTrace stackTrace) {
              Fimber.d('Worker: execute main but FAIL: exception=$exception, '
                  'stackTrace=$stackTrace');
              sendException(sendPort, exception, stackTrace);
            },
          );
        } else {
          Fimber.d('Worker: main2: WorkerResult: result2=$result');
          sendPort.send(_WorkerResult(result, taskId: taskId));
        }
      } else if (message is String) {
        Fimber.d('Worker: execute TaskId=$message');
      } else {
        throw Exception('Message is not a task');
      }
    } on Exception catch (exception, stackTrace) {
      Fimber.d('... Worker: execute Task message=$message but FAIL: '
          'exception=$exception, stackTrace=$stackTrace');
      sendException(sendPort, exception, stackTrace);
    }
  });
}

bool _acceptMessage(
    SendPort sendPort, ReceivePort receivePort, dynamic message) {
  if (message is _WorkerSignal && message.id == closeSignal.id) {
    sendPort.send(closeSignal);
    receivePort.close();
    return false;
  }

  return true;
}

///send exception
void sendException(
    SendPort sendPort, dynamic exception, StackTrace stackTrace) {
  if (exception is Error) {
    exception = Error.safeToString(exception);
  }

  var stackTraceFrames =
      stackTrace != null ? Trace.from(stackTrace).frames : null;

  sendPort.send(_WorkerException(exception, stackTraceFrames));
}
