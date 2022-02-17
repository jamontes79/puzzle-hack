import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/authentication/domain/usecases/i_register.dart';
import 'package:puzzle/core/domain/models/email_model.dart';
import 'package:puzzle/core/domain/models/password_model.dart';

part 'register_event.dart';
part 'register_state.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._register)
      : super(
          const RegisterState(
            email: Email.empty(),
            password: Password.empty(),
            confirmPassword: Password.empty(),
            validating: false,
            errorEmail: false,
            errorPassword: false,
            errorConfirmPassword: false,
            successful: false,
            error: false,
          ),
        ) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<AttemptRegister>(_onAttemptRegister);
  }
  final IRegister _register;
  FutureOr<void> _onEmailChanged(
    EmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    late RegisterState newState;
    try {
      newState = state.copyWith(
        email: Email(event.email),
        validating: false,
        errorEmail: false,
        successful: false,
      );
    } on Exception catch (_) {
      newState = state.copyWith(
        email: const Email.empty(),
        validating: false,
        errorEmail: true,
        successful: false,
        error: false,
      );
    }
    emit(newState);
  }

  FutureOr<void> _onPasswordChanged(
    PasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    late RegisterState newState;
    try {
      newState = state.copyWith(
        password: Password(event.password),
        errorConfirmPassword: _comparePasswords(
          event.password,
          event.confirmPassword,
        ),
        validating: false,
        errorEmail: false,
        successful: false,
      );
    } on Exception catch (_) {
      newState = state.copyWith(
        password: const Password.empty(),
        validating: false,
        errorPassword: true,
        errorConfirmPassword: _comparePasswords(
          event.password,
          event.confirmPassword,
        ),
        successful: false,
        error: false,
      );
    }
    emit(newState);
  }

  FutureOr<void> _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    late RegisterState newState;
    try {
      newState = state.copyWith(
        confirmPassword: Password(event.confirmPassword),
        validating: false,
        errorConfirmPassword:
            _comparePasswords(event.password, event.confirmPassword),
        successful: false,
        error: false,
      );
    } on Exception catch (_) {
      newState = state.copyWith(
        confirmPassword: const Password.empty(),
        errorConfirmPassword:
            _comparePasswords(event.password, event.confirmPassword),
        validating: false,
        successful: false,
        error: false,
      );
    }
    emit(newState);
  }

  Future<FutureOr<void>> _onAttemptRegister(
    AttemptRegister event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        validating: true,
        errorEmail: false,
        errorPassword: false,
        successful: false,
        error: false,
      ),
    );
    final failureOrRegister = await _register.register(
      state.email,
      state.password,
    );
    emit(
      failureOrRegister.fold(
        (l) => state.copyWith(
          validating: false,
          errorEmail: false,
          errorPassword: false,
          successful: false,
          error: true,
        ),
        (r) => state.copyWith(
          validating: false,
          errorEmail: false,
          errorPassword: false,
          successful: true,
          error: false,
        ),
      ),
    );
  }

  bool _comparePasswords(String password, String confirmPassword) {
    return (password != confirmPassword) &&
        (password != '') &&
        (confirmPassword != '');
  }
}
