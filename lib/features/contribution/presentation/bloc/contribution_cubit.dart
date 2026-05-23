import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/contribution_entity.dart';
import '../../domain/usecases/submit_contribution_usecase.dart';

enum ContributionStatus { idle, submitting, success, failure }

class ContributionState extends Equatable {
  const ContributionState({this.status = ContributionStatus.idle, this.error});

  final ContributionStatus status;
  final String? error;

  @override
  List<Object?> get props => [status, error];
}

class ContributionCubit extends Cubit<ContributionState> {
  ContributionCubit(this.submitUseCase) : super(const ContributionState());
  final SubmitContributionUseCase submitUseCase;

  Future<void> submit(ContributionEntity contribution) async {
    emit(const ContributionState(status: ContributionStatus.submitting));
    try {
      await submitUseCase(contribution);
      emit(const ContributionState(status: ContributionStatus.success));
    } catch (e) {
      emit(ContributionState(
        status: ContributionStatus.failure,
        error: e is Failure ? e.message : e.toString(),
      ));
    }
  }

  void reset() => emit(const ContributionState());
}
