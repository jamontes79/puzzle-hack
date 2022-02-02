import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/authentication/domain/usecases/i_login.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._login) : super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<AttemptLogin>(_onAttemptLogin);
    on<AttemptLoginWithGoogle>(_onAttemptLoginWithGoogle);
  }
  final ILogin _login;
  FutureOr<void> _onEmailChanged(
    EmailChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        email: event.email,
        validating: false,
        error: false,
        successful: false,
      ),
    );
  }

  FutureOr<void> _onPasswordChanged(
    PasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        validating: false,
        error: false,
        successful: false,
      ),
    );
  }

  Future<FutureOr<void>> _onAttemptLogin(
    AttemptLogin event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        validating: true,
      ),
    );
    final failureOrLogin = await _login.doLogin(
      state.email,
      state.password,
    );

    failureOrLogin.fold(
      (l) => emit(
        state.copyWith(
          validating: false,
          error: true,
          successful: false,
        ),
      ),
      (r) => emit(
        state.copyWith(
          validating: false,
          error: false,
          successful: true,
        ),
      ),
    );
  }

  Future<FutureOr<void>> _onAttemptLoginWithGoogle(
    AttemptLoginWithGoogle event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        validating: true,
      ),
    );
    final failureOrLogin = await _login.doLoginWithGoogle();

    failureOrLogin.fold(
      (l) => emit(
        state.copyWith(
          validating: false,
          error: true,
          successful: false,
        ),
      ),
      (r) => emit(
        state.copyWith(
          validating: false,
          error: false,
          successful: true,
        ),
      ),
    );
  }
}
