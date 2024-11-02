import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpSSLPinning {
  static Future<IOClient> get _instance async =>
      _client ??= await SSLReader.getIoClient();

  static IOClient? _client;
  static http.Client get client => _client ?? IOClient();

  static Future<void> init() async {
    _client = await _instance;
  }
}

class SSLReader {
  static Future<IOClient> getIoClient() async {
    final sslCert = await rootBundle.load('assets/certificates/moviedb.cer');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

    HttpClient client = HttpClient(context: securityContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);

    return ioClient;
  }
}
