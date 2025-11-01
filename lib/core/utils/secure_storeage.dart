import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> writeApiKey(String key) async {
    await _storage.write(key: 'api_key', value: key);
  }

  Future<String?> readApiKey() async {
    return await _storage.read(key: 'api_key');
  }
}
