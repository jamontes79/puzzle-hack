// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:get_storage/get_storage.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:speech_to_text/speech_to_text.dart' as _i20;

import '../authentication/application/auth/auth_bloc.dart' as _i21;
import '../authentication/application/login/login_bloc.dart' as _i16;
import '../authentication/application/register/register_bloc.dart' as _i17;
import '../authentication/domain/usecases/i_auth.dart' as _i8;
import '../authentication/domain/usecases/i_login.dart' as _i10;
import '../authentication/domain/usecases/i_register.dart' as _i12;
import '../authentication/infrastructure/auth_repository.dart' as _i9;
import '../authentication/infrastructure/login_repository.dart' as _i11;
import '../authentication/infrastructure/register_repository.dart' as _i13;
import '../core/infrastructure/firebase_injectable_module.dart' as _i22;
import '../core/infrastructure/get_storage_injectable_module.dart' as _i23;
import '../core/infrastructure/speech_to_text_injectable_module.dart' as _i24;
import '../settings/application/settings_bloc.dart' as _i18;
import '../settings/domain/usecases/i_accessibility.dart' as _i6;
import '../settings/infrastructure/accessibility_repository.dart' as _i7;
import '../speech/application/speech_bloc.dart' as _i19;
import '../speech/domain/usecases/i_speech_recognition.dart' as _i14;
import '../speech/infrastructure/speech_recognition.dart'
    as _i15; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  final getStorageInjectableModule = _$GetStorageInjectableModule();
  final getSpeechToTextInjectableModule = _$GetSpeechToTextInjectableModule();
  gh.lazySingleton<_i3.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth);
  gh.lazySingleton<_i4.FirebaseFirestore>(
      () => firebaseInjectableModule.firebaseFirestore);
  gh.lazySingleton<_i5.GetStorage>(() => getStorageInjectableModule.storage);
  gh.lazySingleton<_i6.IAccessibility>(
      () => _i7.AccessibilityRepository(get<_i5.GetStorage>()));
  gh.lazySingleton<_i8.IAuth>(
      () => _i9.AuthRepository(get<_i3.FirebaseAuth>()));
  gh.lazySingleton<_i10.ILogin>(
      () => _i11.LoginRepository(get<_i3.FirebaseAuth>()));
  gh.lazySingleton<_i12.IRegister>(
      () => _i13.RegisterRepository(get<_i3.FirebaseAuth>()));
  gh.lazySingleton<_i14.ISpeechRecognition>(() => _i15.SpeechRecognition());
  gh.factory<_i16.LoginBloc>(() => _i16.LoginBloc(get<_i10.ILogin>()));
  gh.factory<_i17.RegisterBloc>(() => _i17.RegisterBloc(get<_i12.IRegister>()));
  gh.factory<_i18.SettingsBloc>(
      () => _i18.SettingsBloc(get<_i6.IAccessibility>()));
  gh.factory<_i19.SpeechBloc>(() => _i19.SpeechBloc());
  gh.lazySingleton<_i20.SpeechToText>(
      () => getSpeechToTextInjectableModule.speechToText);
  gh.factory<_i21.AuthBloc>(() => _i21.AuthBloc(get<_i8.IAuth>()));
  return get;
}

class _$FirebaseInjectableModule extends _i22.FirebaseInjectableModule {}

class _$GetStorageInjectableModule extends _i23.GetStorageInjectableModule {}

class _$GetSpeechToTextInjectableModule
    extends _i24.GetSpeechToTextInjectableModule {}
