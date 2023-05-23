part of './services.dart';

Future<String> getPublicIp() async {
  var response = await http.get(Uri.parse('https://api.ipify.org/'));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get public IP');
  }
}

class ApiServices {
  static final Dio _dio = Dio();

  static int timeOut = 30 * 1000;

  static Future<Options> headerOption() async {
    return Options(
      contentType: Headers.formUrlEncodedContentType,
    );
  }

  static Future httpGet({required String path}) async {
    try {
      final resp = await _dio
          .get(path, options: await headerOption())
          .timeout(Duration(milliseconds: timeOut));
      return resp;
    } on DioError catch (err) {
      debugPrint('error en el Get $err');
      throw (err.response!.data);
    }
  }

  static Future httpPost({required String path, required dynamic data}) async {
    try {
      final resp = await _dio
          .post(path, data: data, options: await headerOption())
          .timeout(Duration(milliseconds: timeOut));

      return resp.data;
    } on DioError catch (err) {
      debugPrint('statusCode: ${err.response!.statusCode}');
      debugPrint('error en el Post ${err.response!.data}');
      //throw (err.response!.data);
    }
  }

  static Future httpPut(
      {required String path, required Map<String, dynamic> data}) async {
    try {
      final resp = await _dio
          .put(path, data: data, options: await headerOption())
          .timeout(Duration(milliseconds: timeOut));

      return resp.data;
    } on DioError catch (err) {
      debugPrint('error en el httpPut $err');
      throw (err.response!.data);
    }
  }

  static Future httpDelete({required String path}) async {
    try {
      final resp = await _dio
          .delete(path, options: await headerOption())
          .timeout(Duration(milliseconds: timeOut));
      return resp.data;
    } on DioError catch (err) {
      debugPrint('error en el httpDelete $err');
      throw (err.response!.data);
    }
  }
}
