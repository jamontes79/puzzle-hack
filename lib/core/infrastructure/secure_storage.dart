import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/core/domain/usecases/i_secure_storage.dart';

@LazySingleton(as: ISecureStorage)
class SecureStorage implements ISecureStorage {
  @override
  Future<bool> contains({required String key}) {
    const storage = FlutterSecureStorage();
    return storage.containsKey(key: key);
  }

  @override
  Future<Unit> delete({required String key}) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: key);
    return unit;
  }

  @override
  Future<String?> read({required String key}) {
    const storage = FlutterSecureStorage();
    return storage.read(key: key);
  }

  @override
  Future<Unit> write({required String key, required String value}) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
    return unit;
  }
}
