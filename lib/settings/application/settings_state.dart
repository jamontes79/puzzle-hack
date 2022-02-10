part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.darkMode = false,
    this.voiceCommands = false,
  });

  final bool darkMode;
  final bool voiceCommands;
  @override
  List<Object> get props => [
        darkMode,
        voiceCommands,
      ];

  SettingsState copyWith({
    bool? darkMode,
    bool? voiceCommands,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      voiceCommands: voiceCommands ?? this.voiceCommands,
    );
  }
}
