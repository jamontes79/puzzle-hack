import 'package:equatable/equatable.dart';

class Ranking extends Equatable {
  const Ranking({
    this.id = '',
    required this.username,
    required this.numberOfMovements,
  });

  final String id;
  final String username;
  final int numberOfMovements;

  @override
  List<Object?> get props => [
        id,
        username,
        numberOfMovements,
      ];
}
