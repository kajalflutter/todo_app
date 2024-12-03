// ignore_for_file: constant_identifier_names
import 'dart:developer';
import 'package:dio/dio.dart';
import 'failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;
  //named constructor
  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // in this case error will be in response api 300 400 500 or from dio itself such as time out or cancel
      failure = _handleError(error);
    } else {
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

Failure _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.BAD_CERTIFICATE.getFailure();
    case DioExceptionType.badResponse:
      if (error.response != null && error.response?.data["error"] != null) {
        String message = error.response?.data["error"];
        return Failure(ResponseCode.BAD_REQUEST, message);
      } else {
        return DataSource.BAD_REQUEST.getFailure();
      }
    //}
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.INTERNAL_SERVER_ERROR.getFailure();
    case DioExceptionType.unknown:
      return DataSource.DEFAULT.getFailure();
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  UNAUTHORIZED,
  NOT_FOUND,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  INTERNAL_SERVER_ERROR,
  FORBIDDEN,
  DEFAULT,
  BAD_CERTIFICATE,
  CONNECTION_ERROR
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      // this = data source
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
      case DataSource.BAD_CERTIFICATE:
        return Failure(ResponseCode.BAD_CERTIFICATE, ResponseMessage.BAD_CERTIFICATE);
      case DataSource.UNAUTHORIZED:
        return Failure(ResponseCode.UNAUTHORIZED, ResponseMessage.UNAUTHORIZED);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND);
      case DataSource.CONNECT_TIMEOUT:
        return Failure(ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT);
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(ResponseCode.RECIEVE_TIMEOUT, ResponseMessage.RECIEVE_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION, ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR, ResponseMessage.INTERNAL_SERVER_ERROR);
      case DataSource.CONNECTION_ERROR:
        return Failure(ResponseCode.CONNECTION_ERROR, ResponseMessage.CONNECTION_ERROR);
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN);
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }
}

class ResponseCode {
  static const int SUCCESS = 200; //sucess with data
  static const int NO_CONTENT = 201; //success with no data (no content)
  static const int BAD_REQUEST = 400; //failure, API rejected request
  static const int UNAUTHORIZED = 401; //failure, user is not authorized
  static const int FORBIDDEN = 403; //failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; //failure, server is not available
  static const int NOT_FOUND = 404;
  static const int BAD_CERTIFICATE = 495; // failure, bad ssl certificate
  static const int CONNECTION_ERROR = 502; // failure, bad ssl certificate

  //local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {
  static const String SUCCESS = "SUCCESS";
  static const String NO_CONTENT = "NO_CONTENT";
  static const String BAD_REQUEST = "BAD_REQUEST";
  static const String UNAUTHORIZED = "UNAUTHORIZED";
  static const String FORBIDDEN = "FORBIDDEN";
  static const String INTERNAL_SERVER_ERROR = "INTERNAL_SERVER_ERROR";
  static const String NOT_FOUND = "NOT_FOUND";
  static const String CONNECT_TIMEOUT = "CONNECT_TIMEOUT";
  static const String CANCEL = "CANCEL";
  static const String RECIEVE_TIMEOUT = "RECIEVE_TIMEOUT";
  static const String SEND_TIMEOUT = "SEND_TIMEOUT";
  static const String CACHE_ERROR = "CACHE_ERROR";
  static const String NO_INTERNET_CONNECTION = "NO_INTERNET_CONNECTION";
  static const String DEFAULT = "UNKNOWN ERROR";
  static const String BAD_CERTIFICATE = "BAD_CERTIFICATE";
  static const String CONNECTION_ERROR = "CONNECTION_ERROR";
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}
