import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/authentication/domain/usecases/i_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._auth) : super(const Unauthenticated()) {
    print('aqui3');
    on<CheckStatus>(_onCheckStatus);
    on<Logout>(_onLogout);
  }
  final IAuth _auth;

  Future<FutureOr<void>> _onCheckStatus(
    CheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    final failureOrUser = await _auth.getSignedUser();
    failureOrUser.fold(
      (failure) => emit(
        const Unauthenticated(),
      ),
      (user) => emit(
        const Authenticated(),
      ),
    );
  }

  Future<FutureOr<void>> _onLogout(
    Logout event,
    Emitter<AuthState> emit,
  ) async {
    await _auth.logout();
    emit(
      const Unauthenticated(),
    );
  }
}
