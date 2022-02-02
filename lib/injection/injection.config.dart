// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;

import '../authentication/application/auth/auth_bloc.dart' as _i11;
import '../authentication/application/login/login_bloc.dart' as _i10;
import '../authentication/domain/usecases/i_auth.dart' as _i6;
import '../authentication/domain/usecases/i_login.dart' as _i8;
import '../authentication/infrastructure/auth_repository.dart' as _i7;
import '../authentication/infrastructure/login_repository.dart' as _i9;
import '../core/infrastructure/firebase_injectable_module.dart'
    as _i12; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  gh.lazySingleton<_i3.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth);
  gh.lazySingleton<_i4.FirebaseFirestore>(
      () => firebaseInjectableModule.firebaseFirestore);
  gh.lazySingleton<_i5.GoogleSignIn>(
      () => firebaseInjectableModule.googleSignIn);
  gh.lazySingleton<_i6.IAuth>(() =>
      _i7.AuthRepository(get<_i3.FirebaseAuth>(), get<_i5.GoogleSignIn>()));
  gh.lazySingleton<_i8.ILogin>(() =>
      _i9.LoginRepository(get<_i3.FirebaseAuth>(), get<_i5.GoogleSignIn>()));
  gh.factory<_i10.LoginBloc>(() => _i10.LoginBloc(get<_i8.ILogin>()));
  gh.factory<_i11.AuthBloc>(() => _i11.AuthBloc(get<_i6.IAuth>()));
  return get;
}

class _$FirebaseInjectableModule extends _i12.FirebaseInjectableModule {}
