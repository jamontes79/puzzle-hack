import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/authentication/domain/usecases/i_auth.dart';
import 'package:puzzle/ranking/domain/failures/ranking_failure.dart';
import 'package:puzzle/ranking/domain/models/ranking.dart';
import 'package:puzzle/ranking/domain/usecases/i_ranking.dart';

part 'ranking_event.dart';
part 'ranking_state.dart';

@injectable
class RankingBloc extends Bloc<RankingEvent, RankingState> {
  RankingBloc(this._rankingRepository, this._auth) : super(RankingInitial()) {
    on<RetrieveRanking>(_onRetrieveRanking);
    on<RankingReceived>(_onRankingReceived);
    on<SaveRanking>(_onSaveRanking);
  }
  final IRanking _rankingRepository;
  final IAuth _auth;
  FutureOr<void> _onRetrieveRanking(
    RetrieveRanking event,
    Emitter<RankingState> emit,
  ) {
    emit(
      RankingLoading(),
    );
    _rankingRepository.watchAll().listen((failureOrRanking) {
      add(
        RankingReceived(failureOrRanking),
      );
    });
  }

  FutureOr<void> _onRankingReceived(
    RankingReceived event,
    Emitter<RankingState> emit,
  ) {
    emit(
      event.failureOrRanking.fold(
        RankingLoadFailure.new,
        RankingLoadSuccessful.new,
      ),
    );
  }

  Future<FutureOr<void>> _onSaveRanking(
    SaveRanking event,
    Emitter<RankingState> emit,
  ) async {
    final failureOrUser = await _auth.getSignedUser();
    failureOrUser.fold(
      (l) => add(
        const RetrieveRanking(),
      ),
      (user) async {
        final ranking = Ranking(
          username: user.username,
          numberOfMovements: event.numberOfMovements,
        );
        await _rankingRepository.create(ranking);
        add(
          const RetrieveRanking(),
        );
      },
    );
  }
}
