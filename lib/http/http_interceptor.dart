
import 'package:dio/dio.dart';

///可以按需要添加拦截器，实现一些通用的功能，例如统一的请求头，统一的参数添加
///下面是例子
///
class CommonHeaderInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) {
//    options.headers.addAll({
//      "deviceId":"123444",
//      "requestId":"ddfsgg"
//    });
    return super.onRequest(options);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  Future<dynamic> onError(DioError err) {
    print(err.type);//也可以区分类型，自定义message;
//    if(null != err.response) {
//      err.message "网络错误请稍后重试(" + err.response.statusCode.toString() + ")";
//    } else if(null != err.request) {
//      err.message = "网络异常，请检查网络情况";
//    }
    return super.onError(err);
  }
}
