import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper {
  static final Dio _dio = Dio();

  static Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }

    // Optional: set base options
    _dio.options.baseUrl = "https://e3a5-197-35-105-32.ngrok-free.app/api/";
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    // Add interceptor for refreshing token automatically
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioError e, ErrorInterceptorHandler handler) async {
        if (e.response?.statusCode == 401) {
          // Try to refresh token
          bool success = await _refreshToken();
          if (success) {
            final request = e.requestOptions;
            final opts = Options(
              method: request.method,
              headers: request.headers,
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
    ));
  }

  static Dio get dio => _dio;

  static Future<bool> _refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh_token');
    if (refresh == null) return false;

    try {
      final response = await _dio.post("token/refresh/", data: {
        "refresh": refresh,
      });

      final newAccess = response.data["access"];
      if (newAccess != null) {
        await prefs.setString('access_token', newAccess);
        _dio.options.headers["Authorization"] = "Bearer $newAccess";
        return true;
      }
    } catch (e) {
      print("Token refresh failed: $e");
    }
    return false;
  }
}
