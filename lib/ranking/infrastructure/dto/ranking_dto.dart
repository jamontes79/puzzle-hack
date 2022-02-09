import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:puzzle/ranking/domain/models/ranking.dart';

class RankingDTO extends Equatable {
  const RankingDTO({
    this.id = '',
    required this.username,
    required this.numberOfMovements,
  });

  factory RankingDTO.fromJson(Map<String, dynamic> json) {
    return RankingDTO(
      id: (json['id'] as String?) ?? '',
      username: json['username'] as String,
      numberOfMovements: json['numberOfMovements'] as int,
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
      username: ranking.user,
      numberOfMovements: ranking.numberOfMovements,
    );
  }

  final String id;
  final String username;
  final int numberOfMovements;

  RankingDTO copyWith({
    String? id,
    String? username,
    int? numberOfMovements,
  }) {
    return RankingDTO(
      id: id ?? this.id,
      username: username ?? this.username,
      numberOfMovements: numberOfMovements ?? this.numberOfMovements,
    );
  }

  Ranking toDomain() {
    return Ranking(
      id: id,
      user: username,
      numberOfMovements: numberOfMovements,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user': username,
      'numberOfMovements': numberOfMovements,
    };
  }

  @override
  List<Object?> get props => [
        id,
        username,
        numberOfMovements,
      ];
}
