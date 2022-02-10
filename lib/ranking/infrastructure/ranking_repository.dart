import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/ranking/domain/failures/ranking_failure.dart';
import 'package:puzzle/ranking/domain/models/ranking.dart';
import 'package:puzzle/ranking/domain/usecases/i_ranking.dart';
import 'package:puzzle/ranking/infrastructure/dto/ranking_dto.dart';

@LazySingleton(
  as: IRanking,
)
class RankingRepository implements IRanking {
  RankingRepository(this._firebaseFirestore);

  final FirebaseFirestore _firebaseFirestore;

  @override
  Stream<Either<RankingFailure, List<Ranking>>> watchAll(int level) async* {
    yield* _firebaseFirestore
        .collection('ranking$level')
        .orderBy('numberOfMovements', descending: false)
        .limit(5)
        .snapshots()
        .map(
      (snapshot) {
        try {
          return right<RankingFailure, List<Ranking>>(
            snapshot.docs
                .map<Ranking>(
                  (doc) => RankingDTO.fromFirestore(doc).toDomain(),
                )
                .toList(),
          );
        } catch (error) {
          return left<RankingFailure, List<Ranking>>(
            const UnexpectedRankingFailure(),
          );
        }
      },
    );
  }

  @override
  Future<Either<RankingFailure, Unit>> create(Ranking ranking) async {
    final rankingDTO = RankingDTO.fromDomain(ranking);
    final inserted =
        await _firebaseFirestore.collection('ranking${ranking.level}').add(
              rankingDTO.toJson(),
            );
    await _firebaseFirestore
        .collection('ranking${ranking.level}')
        .doc(inserted.id)
        .set(
          rankingDTO.copyWith(id: inserted.id).toJson(),
        );
    return right(unit);
  }
}
