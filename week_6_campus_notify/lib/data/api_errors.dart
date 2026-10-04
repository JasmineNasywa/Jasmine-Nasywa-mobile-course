import 'package:dio/dio.dart';

String handleApiError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return "Waktu koneksi habis, coba lagi ya.";
    case DioExceptionType.connectionError:
      return "Kamu sepertinya sedang offline, cek koneksi internetmu.";
    case DioExceptionType.badResponse:
      if (error.response?.statusCode == 401) {
        return "Sesi habis, silakan login ulang.";
      }
      return "Terjadi kesalahan pada server (${error.response?.statusCode}).";
    default:
      return "Terjadi kesalahan yang tidak diketahui.";
  }
}