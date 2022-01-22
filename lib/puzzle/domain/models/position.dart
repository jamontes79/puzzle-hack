import 'package:equatable/equatable.dart';

class Position extends Equatable implements Comparable<Position> {
  const Position({required this.x, required this.y});

  factory Position.fromListPosition({
    required int dimension,
    required int positionInList,
  }) {
    var pos = 0;
    for (var i = 0; i < dimension; i++) {
      for (var j = 0; j < dimension; j++) {
        if (pos == positionInList) {
          return Position(x: i, y: j);
        }
        pos++;
      }
    }
    return const Position(x: 0, y: 0);
  }

  final int x;
  final int y;

  Position replaceWith({required int x, required int y}) {
    return Position(x: x, y: y);
  }

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() {
    return '(x: $x, y: $y)';
  }

  @override
  int compareTo(Position other) {
    if (y < other.y) {
      return -1;
    } else if (y > other.y) {
      return 1;
    } else {
      if (x < other.x) {
        return -1;
      } else if (x > other.x) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}
