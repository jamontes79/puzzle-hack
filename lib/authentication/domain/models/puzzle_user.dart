import 'package:equatable/equatable.dart';

class PuzzleUser extends Equatable {
  const PuzzleUser({required this.id, required this.username});

  final String id;
  final String username;
  @override
  List<Object?> get props => [id, username];
}
