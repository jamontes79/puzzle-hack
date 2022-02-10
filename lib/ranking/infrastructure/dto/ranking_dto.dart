import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:puzzle/ranking/domain/models/ranking.dart';

class RankingDTO extends Equatable {
  const RankingDTO({
    this.id = '',
    required this.username,
    required this.numberOfMovements,
    required this.level,
  });

  factory RankingDTO.fromJson(Map<String, dynamic> json) {
    return RankingDTO(
      id: (json['id'] as String?) ?? '',
      username: json['username'] as String,
      numberOfMovements: json['numberOfMovements'] as int,
      level: json['level'] as int,
    );
  }
  factory RankingDTO.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
  ) {
    return RankingDTO.fromJson(documentSnapshot.data()!).copyWith(
      id: documentSnapshot.id,
    );
  }

  factory RankingDTO.fromDomain(Ranking ranking) {
    return RankingDTO(
      id: ranking.id,
      username: ranking.username.substring(
        0,
        ranking.username.indexOf('@'),
      ),
      numberOfMovements: ranking.numberOfMovements,
      level: ranking.level,
    );
  }

  final String id;
  final String username;
  final int numberOfMovements;
  final int level;
  RankingDTO copyWith({
    String? id,
    String? username,
    int? numberOfMovements,
    int? level,
  }) {
    return RankingDTO(
      id: id ?? this.id,
      username: username ?? this.username,
      numberOfMovements: numberOfMovements ?? this.numberOfMovements,
      level: level ?? this.level,
    );
  }

  Ranking toDomain() {
    return Ranking(
      id: id,
      username: username,
      numberOfMovements: numberOfMovements,
      level: level,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'numberOfMovements': numberOfMovements,
      'level': level,
    };
  }

  @override
  List<Object?> get props => [
        id,
        username,
        numberOfMovements,
      ];
}
