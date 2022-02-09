import 'package:equatable/equatable.dart';

class Ranking extends Equatable {
  const Ranking({
    this.id = '',
    required this.user,
    required this.numberOfMovements,
  });

  final String id;
  final String user;
  final int numberOfMovements;

  @override
  List<Object?> get props => [
        id,
        user,
        numberOfMovements,
      ];
}
