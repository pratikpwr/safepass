import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();

  static final SecureStorage _instance = SecureStorage._();

  factory SecureStorage() {
    return _instance;
  }

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static late encrypt.Key _encryptionKey;
  static late encrypt.IV _iv;

  static late encrypt.Encrypter _encrypter;

  static Future<void> init() async {
    await _getKey();
    await _getIV();
    _encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
  }

  static Future<void> _getKey() async {
    String? key = await _storage.read(key: 'encryptionKey');
    if (key == null) {
      key = encrypt.Key.fromLength(32).base64; // Create a new key if not exists
      await _storage.write(key: 'encryptionKey', value: key);
    }
    _encryptionKey = encrypt.Key.fromBase64(key);
  }

  static Future<void> _getIV() async {
    String? iv64 = await _storage.read(key: 'encryptionIV');
    if (iv64 == null) {
      iv64 = encrypt.IV.fromLength(16).base64; // Create a new key if not exists
      await _storage.write(key: 'encryptionIV', value: iv64);
    }
    _iv = encrypt.IV.fromBase64(iv64);
  }

  String encryptData(String data) {
    final encrypted = _encrypter.encrypt(data, iv: _iv);
    return encrypted.base64;
  }

  String decryptData(String encryptedData) {
    return _encrypter.decrypt64(encryptedData, iv: _iv);
  }
}
