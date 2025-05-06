import 'dart:io';

import 'package:dio/dio.dart';
import 'package:onboarding_project/cubits/auth_cubit.dart';
import 'package:onboarding_project/utils/constants.dart';

import '../models/auth_data.dart';

class DioClient {
  final AuthCubit Function() _getAuthCubitFunc;

  DioClient({required AuthCubit Function() getAuthCubitFunc})
      : _getAuthCubitFunc = getAuthCubitFunc;

  AuthCubit get _authCubit => _getAuthCubitFunc();
  AuthData? get _authData => _authCubit.authData;
  String get _authHeader => _authData?.authHeader ?? '';
  String get _refreshToken => _authData?.refreshToken ?? '';

  Dio getDio(bool useAuthHeader) {
    final baseOptions = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      contentType: Headers.jsonContentType,
    );

    final dio = Dio(baseOptions);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (useAuthHeader) {
          if (_authData?.isExpired ?? false) {
            print('Token expired (onRequest), refreshing...');
            final isSuccess = await _authCubit.tryRefreshToken(_refreshToken);
            print('Is token refresh sucess: $isSuccess');
          }
          final headersToInclude = {
            HttpHeaders.authorizationHeader: _authHeader,
          };
          options.headers.addAll(headersToInclude);
        }
        handler.next(options);
      },
      onError: (error, handler) {
        //TODO: check if token is expired in the response (code 401 or 403) otherwise sign out the user
        print('Request onError: $error');
      },
    ));

    return dio;
  }

  Future<Response> dioRequest({
    required String path,
    String method = 'GET',
    bool useAuthHeader = true,
    dynamic data,
  }) async {
    final Response response;
    try {
      final dio = getDio(useAuthHeader);
      response =
          await dio.request(path, data: data, options: Options(method: method));
    } catch (e) {
      print('dioRequest error: $e');
      rethrow;
    }
    return response;
  }
}
