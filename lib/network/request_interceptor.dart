import 'package:dio/dio.dart';
import 'package:deligo_delivery/utility/helper.dart';

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    Map<String, dynamic> xDeviceInfo = await Helper.getHeadersBase();
    options.headers.addAll(xDeviceInfo);
    options.headers.removeWhere((key, value) => value == null);
    options.queryParameters.removeWhere((key, value) => value == null);
    super.onRequest(options, handler);
  }
}
