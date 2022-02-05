import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'speech_event.dart';
part 'speech_state.dart';

@injectable
class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  SpeechBloc()
      : super(
          const SpeechState(
            coordinate: '',
            listening: false,
          ),
        ) {
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
  }

  FutureOr<void> _onStartListening(
    StartListening event,
    Emitter<SpeechState> emit,
  ) {
    emit(
      state.copyWith(
        listening: true,
      ),
    );
  }

  FutureOr<void> _onStopListening(
    StopListening event,
    Emitter<SpeechState> emit,
  ) {}
}
