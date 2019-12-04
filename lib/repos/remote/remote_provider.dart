import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';
import 'package:travelspots/utils/app_utils.dart';

import '../endpoint.dart';
import '../flt_exception.dart';

/// A class help handle network data
class RemoteProvider {
  /// dio
  Dio dio;

  /// Constructor RemoteProvider
  RemoteProvider({String baseUrl}) {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
    );
    Fimber.d('Init RemoteProvider with endpoint=$baseUrl');
    dio = Dio(options);
    dio.interceptors.add(LogInterceptor(
      responseBody: false,
      //true,
      responseHeader: false,
      error: true,
      request: true,
      requestHeader: true,
      requestBody: true,
    ));
  }

  Future<Response> _get({
    @required String requestName,
    @required String path,
    Map<String, dynamic> queryParams,
  }) async {
    print('$requestName request: params = $queryParams');
    var response = await dio.get(path, queryParameters: queryParams);
    // AppUtils.printWrapped('$requestName response= ${response.toString()}');
    return response;
  }

  Future<Response> _post({
    @required String requestName,
    @required String path,
    @required dynamic postData,
    Map<String, dynamic> queryParams,
  }) async {
    print('$requestName request = $postData');
    Response response = await dio.post(
      path,
      data: postData,
      queryParameters: queryParams,
    );
    /*AppUtils.printWrapped(
      '$requestName response= ${response.toString()}',
    );*/
    return response;
  }

  Future<T> _handlePost<T>({
    @required String requestName,
    @required String path,
    @required dynamic postData,
    Map<String, dynamic> queryParams,
    @required T Function(Response<dynamic>) convertToModel,
  }) async {
    try {
      final response = await _post(
        requestName: requestName,
        path: path,
        postData: postData,
        queryParams: queryParams,
      );
      return convertToModel(response);
    } on Exception catch (e) {
      final ex = ExceptionHelper.newInstance(e, endpoint: path);
      print('requestName=$requestName failed: $ex');
      throw ex;
    }
  }

  Future<T> _handleGet<T>({
    @required String requestName,
    @required String path,
    Map<String, dynamic> queryParams,
    @required T Function(Response<dynamic>) convertToModel,
  }) async {
    try {
      final response = await _get(
        requestName: requestName,
        path: path,
        queryParams: queryParams,
      );
      return convertToModel(response);
    } on Exception catch (e) {
      final ex = ExceptionHelper.newInstance(e, endpoint: path);
      print('_get eror $requestName: $ex');
      throw ex;
    }
  }

  /// Get Spots from Google Sheet
  Future<List<SpotEntity>> getSpotsFromGSheet(
      {String spreadSheetId, String workSheetId, String provinceName}) async {
    return _handleGet(
      requestName: 'getUsersByOrganization',
      path: AppUtils.mapURLPatternValue(Endpoint.getSpotsFromGSheet,
          values: [spreadSheetId, workSheetId]),
      convertToModel: (response) {
        List jsonList = response.data['feed']['entry'];
        return jsonList
            .map((itemJson) => SpotEntity.fromGoogleJson(
                itemJson, '$spreadSheetId-$workSheetId', provinceName))
            .toList();
      },
    );
  }
}
