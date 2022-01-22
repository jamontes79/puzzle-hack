import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:puzzle/puzzle/domain/models/position.dart';

class TilePuzzle extends Equatable {
  const TilePuzzle({
    required this.currentPosition,
    required this.correctPosition,
    required this.isWhite,
    required this.canMove,
    required this.value,
    this.imagePart,
    required this.size,
  });

  final Position currentPosition;
  final Position correctPosition;
  final bool isWhite;
  final bool canMove;
  final int value;
  final Uint8List? imagePart;
  final double size;
  TilePuzzle copyWith({
    Position? currentPosition,
    Position? correctPosition,
    bool? isWhite,
    bool? canMove,
    int? value,
    Uint8List? imagePart,
    double? size,
  }) {
    return TilePuzzle(
      currentPosition: currentPosition ?? this.currentPosition,
      correctPosition: correctPosition ?? this.correctPosition,
      isWhite: isWhite ?? this.isWhite,
      canMove: canMove ?? this.canMove,
      value: value ?? this.value,
      imagePart: imagePart ?? this.imagePart,
      size: size ?? this.size,
    );
  }

  @override
  List<Object?> get props => [
        currentPosition,
        correctPosition,
        isWhite,
        canMove,
        value,
        imagePart,
        size,
      ];

  @override
  String toString() {
    return 'currentPosition: $currentPosition\n'
        'correctPosition: $correctPosition\n'
        'canMove: $canMove';
  }

  bool isAdjacentTo(TilePuzzle tileToCheck) {
    final rowDistance =
        (tileToCheck.currentPosition.x - currentPosition.x).abs();

    final columnDistance =
        (tileToCheck.currentPosition.y - currentPosition.y).abs();

    return (rowDistance == 0 && columnDistance == 1) ||
        (rowDistance == 1 && columnDistance == 0);
  }

  bool get isCorrectPosition => currentPosition == correctPosition;
}
