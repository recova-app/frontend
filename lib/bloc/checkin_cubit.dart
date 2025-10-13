import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recova/models/checkin_result_model.dart';
import 'package:recova/services/api_service.dart';
import 'package:equatable/equatable.dart';

part 'checkin_state.dart';

class CheckinCubit extends Cubit<CheckinState> {
  CheckinCubit() : super(CheckinInitial());

  Future<void> performCheckIn({required String journal}) async {
    if (journal.isEmpty) {
      emit(const CheckinFailure("Isi jurnal terlebih dahulu"));
      return;
    }

    emit(CheckinLoading());
    try {
      final result = await ApiService.checkIn(journal: journal);
      emit(CheckinSuccess(result));
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(CheckinFailure(errorMessage));
    }
  }

  void resetState() {
    emit(CheckinInitial());
  }
}