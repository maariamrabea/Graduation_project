import 'package:dio/dio.dart';
import 'package:graduationproject/ApiConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DioHelper {
  static final Dio _dio = Dio();

  static Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    _dio.options.baseUrl = ApiConstants.dio;
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);

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
        onError: (DioError e, ErrorInterceptorHandler handler) async {
          print('Error: ${e.response?.statusCode} ${e.response?.data}');
          if (e.response?.statusCode == 401) {
            bool success = await _refreshToken();
            if (success) {
              final request = e.requestOptions;
              final opts = Options(
                method: request.method,
                headers: {
                  ...request.headers,
                  'Authorization': _dio.options.headers['Authorization'],
                },
              );
              try {
                final cloneReq = await _dio.request(
                  request.path,
                  options: opts,
                  data: request.data,
                  queryParameters: request.queryParameters,
                );
                return handler.resolve(cloneReq);
              } catch (e) {
                return handler.reject(e as DioError);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Dio get dio => _dio;

  static Future<bool> _refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh_token');
    if (refresh == null) {
      print('No refresh token found');
      return false;
    }

    try {
      final tempDio = Dio();
      tempDio.options.baseUrl = _dio.options.baseUrl;
      tempDio.options.connectTimeout = const Duration(seconds: 10);
      tempDio.options.receiveTimeout = const Duration(seconds: 10);
      tempDio.options.headers['Content-Type'] = 'application/json';

      final response = await tempDio.post(
        'users/token/refresh/',
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
      if (e is DioError) {
        print('Error response: ${e.response?.data}');
      }
    }
    return false;
  }

  static Future<Response> postWithoutAuth(String url, dynamic data) async {
    final options = Options(contentType: 'application/json', headers: {});
    return await _dio.post(url, data: data, options: options);
  }

  static Future<Response> postWithoutAuthRequest(
    String url, {
    dynamic data,
  }) async {
    final Dio tempDio = Dio();
    tempDio.options.headers = {'Content-Type': 'application/json'};
    tempDio.options.connectTimeout = const Duration(seconds: 10);
    tempDio.options.receiveTimeout = const Duration(seconds: 10);
    return await tempDio.post(url, data: data);
  }
}
//git add .
// git commit -m "Link AI model with flutter"
// git push