import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/settings/domain/models/accessibility_settings.dart';
import 'package:puzzle/settings/domain/usecases/i_accessibility.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._accessibility) : super(const SettingsState()) {
    on<ChangeShortcutsEvent>(_onChangeShortcutsEvent);
    on<ChangeVoiceCommandEvent>(_onChangeVoiceCommandEvent);
    on<ChangeStyleEvent>(_onChangeStyleEvent);
    on<RequestAccessibilitySettings>(_onRequestAccessibilitySettings);
    on<SaveAccessibilitySettings>(_onSaveAccessibilitySettings);
  }
  final IAccessibility _accessibility;

  Future<FutureOr<void>> _onChangeVoiceCommandEvent(
    ChangeVoiceCommandEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _accessibility.save(
      AccessibilitySettings(
        keyboardShortcuts: state.shortcuts,
        voiceCommands: event.value,
        darkMode: state.darkMode,
      ),
    );

    emit(
      state.copyWith(voiceCommands: event.value),
    );
  }

  Future<FutureOr<void>> _onChangeStyleEvent(
    ChangeStyleEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _accessibility.save(
      AccessibilitySettings(
        keyboardShortcuts: state.shortcuts,
        voiceCommands: state.voiceCommands,
        darkMode: event.darkMode,
      ),
    );

    emit(
      state.copyWith(darkMode: event.darkMode),
    );
  }

  Future<void> _onRequestAccessibilitySettings(
    RequestAccessibilitySettings event,
    Emitter<SettingsState> emit,
  ) async {
    final failureOrAccessibility = await _accessibility.get();
    failureOrAccessibility.fold(
      (error) {
        emit(
          state.copyWith(
            darkMode: state.darkMode,
            voiceCommands: state.voiceCommands,
          ),
        );
      },
      (accessibility) => emit(
        state.copyWith(
          darkMode: accessibility.darkMode,
          voiceCommands: accessibility.voiceCommands,
          shortcuts: accessibility.keyboardShortcuts,
        ),
      ),
    );
  }

  FutureOr<void> _onChangeShortcutsEvent(
    ChangeShortcutsEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(
      state.copyWith(shortcuts: event.value),
    );
  }

  Future<FutureOr<void>> _onSaveAccessibilitySettings(
    SaveAccessibilitySettings event,
    Emitter<SettingsState> emit,
  ) async {
    await _accessibility.save(
      AccessibilitySettings(
        keyboardShortcuts: state.shortcuts,
        voiceCommands: state.voiceCommands,
        darkMode: state.darkMode,
      ),
    );
  }
}
