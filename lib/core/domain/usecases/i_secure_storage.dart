import 'package:dartz/dartz.dart';

abstract class ISecureStorage {
  Future<bool> contains({required String key});
  Future<String?> read({required String key});
  Future<Unit> delete({required String key});
  Future<Unit> write({required String key, required String value});
}
