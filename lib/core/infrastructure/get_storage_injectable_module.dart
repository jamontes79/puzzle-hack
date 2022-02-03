import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class GetStorageInjectableModule {
  @lazySingleton
  GetStorage get storage => GetStorage();
}
