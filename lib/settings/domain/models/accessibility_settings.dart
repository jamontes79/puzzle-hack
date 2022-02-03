import 'package:equatable/equatable.dart';

class AccessibilitySettings extends Equatable {
  const AccessibilitySettings({
    this.keyboardShortcuts = true,
    this.voiceCommands = false,
    this.darkMode = false,
    this.zoomLevel = 100,
  });

  factory AccessibilitySettings.fromJson(Map<String, dynamic> json) {
    return AccessibilitySettings(
      keyboardShortcuts: json['keyboardShortcuts'] as bool,
      voiceCommands: json['plainText'] as bool,
      darkMode: json['darkMode'] as bool,
      zoomLevel: json['zoomLevel'] as double,
    );
  }
  final bool keyboardShortcuts;
  final bool voiceCommands;
  final bool darkMode;
  final double zoomLevel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'keyboardShortcuts': keyboardShortcuts,
      'plainText': voiceCommands,
      'darkMode': darkMode,
      'zoomLevel': zoomLevel,
    };
  }

  @override
  List<Object?> get props => [
        keyboardShortcuts,
        voiceCommands,
        darkMode,
        zoomLevel,
      ];
}
