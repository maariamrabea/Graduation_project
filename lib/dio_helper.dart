import 'package:dio/dio.dart';
import 'package:graduationproject/ApiConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

//
// class DioHelper {
//   static final Dio _dio = Dio();
//
//   static Future<void> init() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('access_token');
//
//     _dio.options.baseUrl =
//         ApiConstants
//             .dio; // تأكد أن ApiConstants.dio هو الـ base url الصحيح (مثلاً: "http://192.168.1.100:8000/api/")
//     _dio.options.connectTimeout = const Duration(seconds: 30);
//     _dio.options.receiveTimeout = const Duration(seconds: 30);
//
//     if (token != null) {
//       _dio.options.headers['Authorization'] = 'Bearer $token';
//       print('DioHelper initialized with token: $token');
//     } else {
//       print('DioHelper initialized without token.');
//     }
//
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           print('Request: ${options.method} ${options.uri}');
//           print('Headers: ${options.headers}');
//           if (options.data != null) {
//             print('Data: ${options.data}');
//           }
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           print('Response Status: ${response.statusCode}');
//           print('Response Data: ${response.data}');
//           return handler.next(response);
//         },
//         onError: (DioException e, ErrorInterceptorHandler handler) async {
//           print('Error Response Status: ${e.response?.statusCode}');
//           print('Error Response Data: ${e.response?.data}');
//           print('Error Type: ${e.type}, Message: ${e.message}');
//
//           if (e.response?.statusCode == 401 &&
//               e.requestOptions.path != 'token/refresh/') {
//             final refreshed = await _refreshToken();
//             if (refreshed) {
//               print('Token refreshed, retrying original request...');
//               return handler.resolve(await _retry(e.requestOptions));
//             } else {
//               // إذا فشل التحديث، قم بتسجيل الخروج أو إرسال المستخدم لصفحة تسجيل الدخول
//               print('Failed to refresh token. User might need to re-login.');
//               // يمكنك هنا إضافة لوجيك لتسجيل خروج المستخدم
//               // مثلاً: Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
//             }
//           }
//           return handler.next(e);
//         },
//       ),
//     );
//   }
//
//   static Dio get dio => _dio;
//   static Future<Response> getWithAuthRequest(
//     String url, {
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     try {
//       return await _dio.get(
//         url,
//         queryParameters: queryParameters,
//         options: options,
//       );
//     } catch (e) {
//       print('Exception in getWithAuthRequest: $e');
//       rethrow;
//     }
//   }
//
//   static Future<Response> putWithAuthRequest(
//     String url, {
//     dynamic data,
//     Options? options,
//   }) async {
//     try {
//       return await _dio.put(url, data: data, options: options);
//     } catch (e) {
//       print('Exception in putWithAuthRequest: $e');
//       rethrow;
//     }
//   }
//
//   static Future<bool> refreshToken() async {
//     return _refreshToken();
//   }
//
//   static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
//     final options = Options(
//       method: requestOptions.method,
//       headers: requestOptions.headers,
//     );
//     return _dio.request(
//       requestOptions.path,
//       data: requestOptions.data,
//       options: options,
//     );
//   }
//
//   static Future<bool> _refreshToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final refresh = prefs.getString('refresh_token');
//     if (refresh == null) {
//       print('No refresh token found');
//       // إذا لم يكن هناك refresh token، قم بتنظيف التوكنات القديمة وأرسل المستخدم لصفحة تسجيل الدخول
//       await prefs.remove('access_token');
//       // قد تحتاج لتوجيه المستخدم لصفحة تسجيل الدخول هنا
//       return false;
//     }
//
//     try {
//       // استخدم _dio نفسه لتحديث التوكن
//       // تأكد أن headers لا تحتوي على Authorization هنا لتجنب حلقة مفرغة
//       final oldHeaders = Map<String, dynamic>.from(_dio.options.headers);
//       _dio.options.headers.remove(
//         'Authorization',
//       ); // إزالة الهيدر للمنع من استخدام التوكن القديم لتحديث التوكن نفسه
//
//       final response = await _dio.post(
//         // استخدام _dio بدلاً من tempDio
//         'token/refresh/', // هذا المسار يجب أن يكون مرتبط بـ baseUrl
//         data: {'refresh': refresh},
//       );
//
//       _dio.options.headers.addAll(oldHeaders); // استعادة الهيدرات الأصلية
//
//       final newAccess = response.data['access'];
//       final newRefresh = response.data['refresh'];
//
//       if (newAccess != null) {
//         await prefs.setString('access_token', newAccess);
//         if (newRefresh != null) {
//           await prefs.setString('refresh_token', newRefresh);
//         }
//         _dio.options.headers['Authorization'] = 'Bearer $newAccess';
//         print('Token refreshed successfully and Dio header updated.');
//         return true;
//       }
//     } on DioException catch (e) {
//       print(
//         'DioException during token refresh: ${e.response?.statusCode} ${e.response?.data}',
//       );
//       // هنا يمكن إضافة لوجيك لتنظيف التوكنات وتوجيه المستخدم لصفحة تسجيل الدخول إذا فشل التحديث
//       await prefs.remove('access_token');
//       await prefs.remove('refresh_token');
//       await prefs.remove('user_id');
//       await prefs.remove('user_type');
//       // يمكن إضافة Navigator.pushAndRemoveUntil لتوجيه المستخدم لصفحة تسجيل الدخول
//     } catch (e) {
//       print('Unexpected error during token refresh: $e');
//     }
//     return false;
//   }
//
//   static Future<Response> postWithoutAuthRequest(
//     String url, {
//     dynamic data,
//     Options? options,
//   }) async {
//     final Dio tempDio = Dio(); // هنا استخدام tempDio منطقي لأنه بدون Auth
//     tempDio.options.baseUrl = ApiConstants.dio;
//     tempDio.options.headers = {'Content-Type': 'application/json'};
//     tempDio.options.connectTimeout = const Duration(seconds: 30);
//     tempDio.options.receiveTimeout = const Duration(seconds: 30);
//
//     tempDio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           print('Non-Auth Request: ${options.method} ${options.uri}');
//           print('Headers: ${options.headers}');
//           if (options.data != null) {
//             print('Data: ${options.data}');
//           }
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           print('Non-Auth Response: ${response.statusCode} ${response.data}');
//           return handler.next(response);
//         },
//         onError: (DioException e, handler) {
//           print(
//             'Non-Auth Error: ${e.response?.statusCode} ${e.response?.data}',
//           );
//           print('Non-Auth Error Type: ${e.type}, Message: ${e.message}');
//           return handler.next(e);
//         },
//       ),
//     );
//
//     try {
//       return await tempDio.post(url, data: data, options: options);
//     } catch (e) {
//       print('Exception in postWithoutAuthRequest: $e');
//       rethrow;
//     }
//   }
//
//   // في DioHelper
//   // ... (الكود الموجود لديك)
//
//   // ****** دوال POST التي تستخدم الـ _dio المثبت مع الـ Auth Header ******
//   static Future<Response> postWithAuthRequest(
//     String url, {
//     dynamic data,
//     Options? options,
//   }) async {
//     try {
//       return await _dio.post(url, data: data, options: options);
//     } catch (e) {
//       print('Exception in postWithAuthRequest: $e');
//       rethrow;
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiConstants.dart'; // استورد كلاس ApiConstants
import 'package:flutter/material.dart'; // للـNavigator لو محتاج

class DioHelper {
  static final Dio _dio = Dio();

  static Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    _dio.options.baseUrl = ApiConstants.dio;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.options.headers['Content-Type'] = 'application/json';
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      print('DioHelper initialized with token: $token');
    } else {
      print('DioHelper initialized without token.');
    }

    _setupInterceptors();
  }

  static void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Request: ${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
          if (options.data != null) {
            print('Data: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response Status: ${response.statusCode}');
          print('Response Data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          print('Error Response Status: ${e.response?.statusCode}');
          print('Error Response Data: ${e.response?.data}');
          print('Error Type: ${e.type}, Message: ${e.message}');

          if (e.response?.statusCode == 401 &&
              e.requestOptions.path != 'token/refresh/') {
            final refreshed = await _refreshToken();
            if (refreshed) {
              print('Token refreshed, retrying original request...');
              return handler.resolve(await _retry(e.requestOptions));
            } else {
              print('Failed to refresh token. Logging out...');
              await _logout();
              // توجيه لصفحة تسجيل الدخول (افتراضيًا context global)
              // يمكنك تعديل هذا الجزء حسب احتياجاتك
              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Dio get dio => _dio;

  static Future<Response> getWithAuthRequest(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      print('Exception in getWithAuthRequest: $e');
      rethrow;
    }
  }

  static Future<Response> patchWithAuthRequest(
      String url, {
        dynamic data,
        Options? options,
      }) async {
    try {
      return await _dio.patch(url, data: data, options: options);
    } catch (e) {
      print('Exception in patchWithAuthRequest: $e');
      rethrow;
    }
  }

  static Future<Response> putWithAuthRequest(
      String url, {
        dynamic data,
        Options? options,
      }) async {
    try {
      return await _dio.put(url, data: data, options: options);
    } catch (e) {
      print('Exception in putWithAuthRequest: $e');
      rethrow;
    }
  }

  static Future<bool> refreshToken() async {
    return _refreshToken();
  }

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  static Future<bool> _refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh_token');
    if (refresh == null) {
      print('No refresh token found');
      await _logout();
      return false;
    }

    try {
      final oldHeaders = Map<String, dynamic>.from(_dio.options.headers);
      _dio.options.headers.remove('Authorization');

      final response = await _dio.post(
        'token/refresh/',
        data: {'refresh': refresh},
      );

      _dio.options.headers.addAll(oldHeaders);
      final newAccess = response.data['access'];
      final newRefresh = response.data['refresh'];

      if (newAccess != null) {
        await prefs.setString('access_token', newAccess);
        if (newRefresh != null) {
          await prefs.setString('refresh_token', newRefresh);
        }
        _dio.options.headers['Authorization'] = 'Bearer $newAccess';
        print('Token refreshed successfully and Dio header updated.');
        return true;
      }
    } on DioException catch (e) {
      print('DioException during token refresh: ${e.response?.statusCode} ${e.response?.data}');
      await _logout();
    } catch (e) {
      print('Unexpected error during token refresh: $e');
      await _logout();
    }
    return false;
  }

  static Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_id');
    await prefs.remove('user_type');
    print('User logged out due to token refresh failure.');
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
          print('Non-Auth Request: ${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
          if (options.data != null) {
            print('Data: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Non-Auth Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('Non-Auth Error: ${e.response?.statusCode} ${e.response?.data}');
          print('Non-Auth Error Type: ${e.type}, Message: ${e.message}');
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

  static Future<Response> postWithAuthRequest(
      String url, {
        dynamic data,
        Options? options,
      }) async {
    try {
      return await _dio.post(url, data: data, options: options);
    } catch (e) {
      print('Exception in postWithAuthRequest: $e');
      rethrow;
    }
  }
}