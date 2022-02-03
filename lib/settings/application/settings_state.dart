part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.darkMode = false,
    this.voiceCommands = false,
    this.shortcuts = true,
  });

  final bool darkMode;
  final bool voiceCommands;
  final bool shortcuts;
  @override
  List<Object> get props => [
        darkMode,
        voiceCommands,
        shortcuts,
      ];

  SettingsState copyWith({
    bool? darkMode,
    bool? voiceCommands,
    bool? shortcuts,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      voiceCommands: voiceCommands ?? this.voiceCommands,
      shortcuts: shortcuts ?? this.shortcuts,
    );
  }
}
