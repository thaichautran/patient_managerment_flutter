import '/config/storage_keys.dart';
import 'package:nylo_framework/nylo_framework.dart';

class BearerAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? userToken = Backpack.instance.read('userToken');
    if (userToken != null) {
      options.headers.addAll({"Authorization": "Bearer $userToken"});
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException dioException, ErrorInterceptorHandler handler) {
    handler.next(dioException);
  }
}
