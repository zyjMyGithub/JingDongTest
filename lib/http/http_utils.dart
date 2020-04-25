import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:jingdong_app/http/http_exception.dart';



//这里我们封装一下Dio的请求框架
const String GET = "get";
const String POST = "post";

const String HOST = "https://wxmini.baixingliangfan.cn/baixing/";
const int CONNECT_TIMEOUT = 10000;
const int RECEIVE_TIMEOUT = 3000;
typedef ErrorCallback = void Function(int count, String msg);

class HttpApi{
  static HttpApi _instance;
  Dio _dio;
  BaseOptions _baseOptions;

  static HttpApi getInstance(){
    if(_instance == null){
      _instance = HttpApi._init();
    }
    return _instance;
  }

  HttpApi._init(){
    _baseOptions = BaseOptions(
        contentType: "application/x-www-form-urlencoded",
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        baseUrl: HOST);
    _dio = new Dio(_baseOptions);
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
      client.badCertificateCallback = (X509Certificate cert ,String host ,int port) {
        return true;
      };
    };
  }

  //添加拦截器
  //拦截器添加
  addInterceptor(Interceptor interceptor) {
    if (null != _dio) {
      _dio.interceptors.add(interceptor);
    }
  }

  addInterceptors(List<Interceptor> interceptorList) {
    if (null != _dio) {
      _dio.interceptors.addAll(interceptorList);
    }
  }

  //get请求
  Future getRequest(String path,{queryParameters}){
    return request(path, GET, postData:queryParameters);
  }
  //封装基础请求
  Future request(String path, String mode,{postData}) async {
    try {
      Response _response;
      switch (mode) {
        case GET:
          if(postData == null){
            _response = await _dio.get(path);
          }else{
            _response = await _dio.get(path,queryParameters: postData);
          }
          return _response.data;
        case POST:
        //做一层json 转换
          if(postData == null){
            _response = await _dio.post(path);
          }else{
            _response = await _dio.post(path, data: postData);
          }
          return _response.data;
      }
    } on DioError catch (exception) {
      print(exception.message);
      return new HttpIOException(exception.response.statusCode, exception.message);
    } catch (error) {
      return new HttpIOException(-2, error.toString());
    }
    return new HttpIOException(-1, "not supported");
  }

  //post请求
  Future postRequest(String path, {postData}){
    return request(path, POST, postData: postData);
  }

}