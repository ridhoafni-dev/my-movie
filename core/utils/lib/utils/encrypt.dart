import 'package:encrypt/encrypt.dart';

String encrypt(String planText) {
  final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(planText, iv: iv);

  return encrypted.base64;
}