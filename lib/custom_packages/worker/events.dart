library worker.events;

import 'worker.dart';

/// Creating WorkerEvent as base to manage the isolates
class WorkerEvent {
  /// isolate type
  final String type;

  /// isolate
  final WorkerIsolate isolate;

  /// Constructor WorkerEvent
  WorkerEvent(this.type, this.isolate);
}

/// Creating IsolateSpawnedEvent
class IsolateSpawnedEvent extends WorkerEvent {
  /// Constructor IsolateSpawnedEvent
  IsolateSpawnedEvent(WorkerIsolate isolate) : super('isolateSpawned', isolate);
}

/// Creating IsolateClosedEvent
class IsolateClosedEvent extends WorkerEvent {
  /// Constructor IsolateClosedEvent
  IsolateClosedEvent(WorkerIsolate isolate) : super('isolateClosed', isolate);
}

/// Creating TaskScheduledEvent
class TaskScheduledEvent extends WorkerEvent {
  /// Task to execute
  final Task task;

  /// Constructor TaskScheduledEvent
  TaskScheduledEvent(WorkerIsolate isolate, this.task)
      : super('taskScheduled', isolate);
}

/// Creating TaskCompletedEvent when executing completely
class TaskCompletedEvent extends WorkerEvent {
  /// Task to execute
  final Task task;

  /// Result to execute
  final dynamic result;

  /// Constructor TaskCompletedEvent
  TaskCompletedEvent(WorkerIsolate isolate, this.task, this.result)
      : super('taskCompleted', isolate);
}

/// Creating TaskFailedEvent when executing failed
class TaskFailedEvent extends WorkerEvent {
  /// Task to execute
  final Task task;

  /// Error to execute
  final dynamic error;

  /// stack trace
  final StackTrace stackTrace;

  /// Constructor TaskFailedEvent
  TaskFailedEvent(WorkerIsolate isolate, this.task, this.error,
      [this.stackTrace])
      : super('taskFailed', isolate);
}
