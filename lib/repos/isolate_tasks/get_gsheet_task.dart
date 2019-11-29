import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:travelspots/custom_packages/worker/worker.dart';
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';
import 'package:travelspots/repos/remote/remote_provider.dart';

/// A isolate task for getting users of organization
class GetGSheetTask implements Task<Future<List<SpotEntity>>> {
  /// Remote provider
  final RemoteProvider remoteProvider;

  /// SpreadSheet Id
  final String spreadSheetId;

  /// WorkSheet Id
  final String workSheetId;

  /// Name of province corresponding to that sheet
  final String provinceName;

  /// Constructor GetGSheetTask
  GetGSheetTask(
      {@required this.remoteProvider,
      @required this.spreadSheetId,
      @required this.workSheetId,
      @required this.provinceName});

  @override
  Future<List<SpotEntity>> execute() async {
    Completer<List<SpotEntity>> completer = Completer();

    try {
      List<SpotEntity> _result = await remoteProvider.getSpotsFromGSheet(
          spreadSheetId: spreadSheetId,
          workSheetId: workSheetId,
          provinceName: provinceName);
      Fimber.e('GetGSheetTask DONE result = ', ex: _result);
      completer.complete(_result);
    } on Exception catch (e) {
      Fimber.e('GetGSheetTask error = ', ex: e);
      completer.completeError(e);
    }

    return completer.future;
  }
}
