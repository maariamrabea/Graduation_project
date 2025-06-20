import 'package:dio/dio.dart';
import 'package:graduationproject/ApiConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DioHelper {
  static final Dio _dio = Dio();

  static Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    _dio.options.baseUrl = ApiConstants.dio;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Request: ${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
          print('Data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          print('Error: ${e.response?.statusCode} ${e.response?.data}');
          print('Error Type: ${e.type}, Message: ${e.message}');
          if (e.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              return handler.resolve(await _retry(e.requestOptions));
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Dio get dio => _dio;

  static Future<bool> refreshToken() async {
    return _refreshToken();
  }

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request(requestOptions.path, data: requestOptions.data, options: options);
  }

  static Future<bool> _refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh_token');
    if (refresh == null) {
      print('No refresh token found');
      return false;
    }

    try {
      final tempDio = Dio();
      tempDio.options.baseUrl = ApiConstants.dio;
      tempDio.options.connectTimeout = const Duration(seconds: 30);
      tempDio.options.receiveTimeout = const Duration(seconds: 30);
      tempDio.options.headers['Content-Type'] = 'application/json';

      final response = await tempDio.post(
        'token/refresh/',
        data: {'refresh': refresh},
      );

      final newAccess = response.data['access'];
      final newRefresh = response.data['refresh'];

      if (newAccess != null) {
        await prefs.setString('access_token', newAccess);
        if (newRefresh != null) {
          await prefs.setString('refresh_token', newRefresh);
        }
        _dio.options.headers['Authorization'] = 'Bearer $newAccess';
        print('Token refreshed successfully');
        return true;
      }
    } catch (e) {
      print('Token refresh failed: $e');
      if (e is DioException) {
        print('Error response: ${e.response?.data}');
      }
    }
    return false;
  }

  static Future<Response> postWithoutAuthRequest(
      String url, {
        dynamic data,
        Options? options,
      }) async {
    final Dio tempDio = Dio();
    tempDio.options.baseUrl = ApiConstants.dio;
    tempDio.options.headers = {'Content-Type': 'application/json'};
    tempDio.options.connectTimeout = const Duration(seconds: 30);
    tempDio.options.receiveTimeout = const Duration(seconds: 30);

    tempDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Request Details: ${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
          print('Data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('Error: ${e.response?.statusCode} ${e.response?.data}');
          print('Error Type: ${e.type}, Message: ${e.message}');
          return handler.next(e);
        },
      ),
    );

    try {
      return await tempDio.post(url, data: data, options: options);
    } catch (e) {
      print('Exception in postWithoutAuthRequest: $e');
      rethrow;
    }
  }
}