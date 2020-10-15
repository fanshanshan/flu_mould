import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// 网络服务
class HttpUtils {
  static Dio _dio = null;
  static const String baseUrl="http:www.baidu.com/";
  // 单例公开访问点
  factory HttpUtils() =>sharedInstance();
  // 静态私有成员，没有初始化
  static HttpUtils _instance = HttpUtils._();

  // 获取网络实例
  static HttpUtils sharedInstance(){
    if(_instance==null){
      _instance = HttpUtils._();
    }
    return _instance;
  }

  // 私有构造函数
  HttpUtils._() {
    if (_dio == null){
      // 具体初始化代码
      BaseOptions options = BaseOptions();
      // 配置dio实例
      options.baseUrl = baseUrl;
      /// 连接服务器超时时间，单位是毫秒.
      options.connectTimeout = 15000; //15s
      /// 接收数据的最长时限.
      options.receiveTimeout = 10000;//10s
      /// 初始化网络库
      _dio = Dio(options);
    }
    _addStartHttpInterceptor(_dio);
  }





  static final String GET = "get";
  static final String POST = "post";
  static final String DATA = "data";
  static final String CODE = "code";
  static final String MSG = "exceptions";

  String getDefaultErrorResponse(){
    return "";
  }


  Future<String> request(String url,
      {params, method,cancelToken}) async {
    int code;
    Response response;
    if (method == GET) {
      if (params != null && params.isNotEmpty) {
        response = await _dio.get(url, queryParameters: params,cancelToken: cancelToken??=CancelToken()).catchError((e){
          return getDefaultErrorResponse();
        });;
      } else {
        response = await _dio.get(url,cancelToken: cancelToken??=CancelToken()).catchError((e){
          return getDefaultErrorResponse();
        });;
      }
    } else if (method == POST) {
      //post(AppUrl.buildingListUrl, queryParameters: params)
      if (params != null && params.isNotEmpty) {
        response = await _dio.post(url, queryParameters: params,cancelToken: cancelToken??=CancelToken()).catchError((e){
          return getDefaultErrorResponse();
        });
      } else {
        response = await _dio.post(url,cancelToken: cancelToken??=CancelToken()).catchError((e){
          return getDefaultErrorResponse();
        });;
      }
    }
    code = response.statusCode;
    if (code != 200) {
      return "${response.statusMessage}";
    } else {
      //请求成功 解析数据  自定义处理
      String dataStr = json.encode(response.data);
      return dataStr;
    }
  }





  Future<String> requestWithCallback(String url,
      {params, method,cancelToken,onSucc,onError}) async {
    int code;
    Response response;
    if (method == GET) {
      if (params != null && params.isNotEmpty) {
        response = await _dio.get(url, queryParameters: params,cancelToken: cancelToken??=CancelToken()).catchError((e){
          onError(getDefaultErrorResponse());
        });;
      } else {
        response = await _dio.get(url,cancelToken: cancelToken??=CancelToken()).catchError((e){
          onError(getDefaultErrorResponse());
        });;
      }
    } else if (method == POST) {
      //post(AppUrl.buildingListUrl, queryParameters: params)
      if (params != null && params.isNotEmpty) {
        response = await _dio.post(url, queryParameters: params,cancelToken: cancelToken??=CancelToken()).catchError((e){
          onError(getDefaultErrorResponse());
        });
      } else {
        response = await _dio.post(url,cancelToken: cancelToken??=CancelToken()).catchError((e){
          onError(getDefaultErrorResponse());
        });;
      }
    }
    code = response.statusCode;
    if (code != 200) {
      onError(response.statusMessage);
    } else {
      //请求成功 解析数据  自定义处理
      String dataStr = json.encode(response.data);
      onSucc(dataStr);
    }
  }



  static _addStartHttpInterceptor(Dio dio) {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("\n李================== 请求数据 ==========================i");
      print("url = ${options.uri.toString()}");
      print("headers = ${options.headers}");
      print("params = ${options.data}");
    }, onResponse: (Response response) {
      print("\n一================== 响应数据 ==========================miss");
      print("code = ${response.statusCode}");
      print("data = ${response.data}");
      print("\n");
    }, onError: (DioError e) {
      print("发生异常了");
      print("errorData${e.response}");
      print("\n媛================== 错误响应数据 ======================you");
      print("type = ${e.type}");
      print("message = ${e.message}");
      print("stackTrace = ${e.message}");
      print("\n");
    }));
  }

}