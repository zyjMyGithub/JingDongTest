

//自定义一个网络请求的异常类

class HttpIOException implements Exception{

  int code;
  String message;
  HttpIOException(this.code,this.message);
}