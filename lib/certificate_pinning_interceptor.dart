import 'dart:async';

import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class CertificatePinningInterceptor extends Interceptor {
  final List<String> allowedSHAFingerprints;
  final String basePath;

  CertificatePinningInterceptor({this.allowedSHAFingerprints,this.basePath});

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final secure = await HttpCertificatePinning.check(
        serverURL: basePath == null || basePath =="" ? options.baseUrl : basePath,
        headerHttp: options.headers.map((a, b) => MapEntry(a, b.toString())),
        sha: SHA.SHA256,
        allowedSHAFingerprints: allowedSHAFingerprints,
        timeout: 50);

    if (secure.contains("CONNECTION_SECURE")) {
      return super.onRequest(options, handler);
    } else {
      throw Exception("CONNECTION_NOT_SECURE");
    }
  }
}
