library worker.core;

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:fimber/fimber.dart';
import 'package:stack_trace/stack_trace.dart';

import 'events.dart';

part 'worker_impl.dart';
part 'worker_isolate_src.dart';

/// A concurrent [Task] executor.
///
/// A [Worker] creates and manages a pool of isolates providing you with an easy
/// way to perform blocking tasks concurrently.
/// It spawns isolates lazily as [Task]s
/// are required to execute.

abstract class Worker {
  /// isClosed
  bool get isClosed;

  /// Size of the pool of isolates.
  int poolSize;

  /// All spawned isolates
  Queue<WorkerIsolate> get isolates;

  /// Spawned isolates that are free to handle more tasks.
  Iterable<WorkerIsolate> get availableIsolates;

  /// Isolates that are currently performing a task.
  Iterable<WorkerIsolate> get workingIsolates;

  /// Stream of isolate spawned events.
  Stream<IsolateSpawnedEvent> get onIsolateSpawned;

  /// Stream of isolate closed events.
  Stream<IsolateClosedEvent> get onIsolateClosed;

  /// Stream of task scheduled events.
  Stream<TaskScheduledEvent> get onTaskScheduled;

  /// Stream of task completed events.
  Stream<TaskCompletedEvent> get onTaskCompleted;

  /// Stream of task failed events.
  Stream<TaskFailedEvent> get onTaskFailed;

  /// Constructor Worker
  factory Worker({int poolSize, bool spawnLazily = true}) {
    poolSize ??= Platform.numberOfProcessors;

    return _WorkerImpl(poolSize: poolSize, spawnLazily: spawnLazily);
  }

  /// Returns a [Future] with the result of the execution of the [Task].
  Future handle(Task task, {Function(TransferProgress progress) callback});

  /// Closes the [ReceivePort] of the isolates.
  /// Waits until all scheduled tasks have completed if [afterDone] is `true`.
  Future<Worker> close({bool afterDone});
}

/// A representation of an isolate
///
/// A representation of an isolate containing a [SendPort] to it and the tasks
/// that are running on it.
abstract class WorkerIsolate {
  /// check isClosed
  bool get isClosed;

  /// check isFree
  bool get isFree;

  /// check runningTask
  Task get runningTask;

  /// get scheduledTasks
  List<Task> get scheduledTasks;

  /// define taskId
  String taskId;

  /// Stream of task spawned events.
  Stream<IsolateSpawnedEvent> get onSpawned;

  /// Stream of task closed events.
  Stream<IsolateClosedEvent> get onClosed;

  /// Stream of task scheduled events.
  Stream<TaskScheduledEvent> get onTaskScheduled;

  /// Stream of task completed events.
  Stream<TaskCompletedEvent> get onTaskCompleted;

  /// Stream of task failed events.
  Stream<TaskFailedEvent> get onTaskFailed;

  ///Constructor WorkerIsolate
  factory WorkerIsolate() => _WorkerIsolateImpl();

  /// perfomTask
  Future performTask(Task task, {Function(TransferProgress progress) callback});

  /// Closes the [ReceivePort] of the isolate.
  /// Waits until all scheduled tasks have completed if [afterDone] is `true`.
  Future<WorkerIsolate> close({bool afterDone});
}

/// A representation of task cancelled exception
class TaskCancelledException implements Exception {
  /// Task to execute
  final Task task;

  /// Constuctor TaskCancelledException
  TaskCancelledException(this.task);

  @override
  String toString() => '$task cancelled.';
}

/// A task that needs to be executed.
///
/// This class provides an interface for tasks.
// ignore: one_member_abstracts
abstract class Task<T> {
  /// abstract execute method
  T execute();
}

typedef ProgressCallback = void Function(int count, int total);

/// Creating FileTask with generic data type
abstract class FileTask<T> extends Task<T> {
  /// progress callback
  ProgressCallback taskProgressCallback;

  /// taskId
  String taskId;

  /// actionType
  ActionType actionType;

  /// handle Cancle
  void handleCancel(String taskId);
}

/// enum ActionType
enum ActionType {
  /// uploate type
  upload,

  /// download type
  download,

  /// cancelUpload type
  cancelUpload,

  /// cancelDownload type
  cancelDownload
}

/// Creating TransferProgress
class TransferProgress {
  /// count
  final int count;

  /// total
  final int total;

  /// constructor TransferProgress
  const TransferProgress({this.count, this.total});
}
