import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_today_inspections_usecase.dart';
import 'today_inspection_event.dart';
import 'today_inspection_state.dart';

/// TodayInspectionBloc — quản lý state trang「今日巡檢」của 巡檢人員 (Inspector)
///
/// Events → States:
///   TodayInspectionLoadTasks → TodayInspectionLoading → TodayInspectionLoaded | TodayInspectionError
///   TodayInspectionRefreshed → TodayInspectionLoaded(isRefreshing: true) → TodayInspectionLoaded
class TodayInspectionBloc
    extends Bloc<TodayInspectionEvent, TodayInspectionState> {
  final GetTodayInspectionsUseCase _getTodayInspectionsUseCase;

  TodayInspectionBloc({
    required GetTodayInspectionsUseCase getTodayInspectionsUseCase,
  })  : _getTodayInspectionsUseCase = getTodayInspectionsUseCase,
        super(const TodayInspectionInitial()) {
    on<TodayInspectionLoadTasks>(_onLoadTasks);
    on<TodayInspectionRefreshed>(_onRefreshed);
  }

  Future<void> _onLoadTasks(
    TodayInspectionLoadTasks event,
    Emitter<TodayInspectionState> emit,
  ) async {
    emit(const TodayInspectionLoading());
    final result = await _getTodayInspectionsUseCase(NoParams());
    result.fold(
      (failure) => emit(TodayInspectionError(message: failure.message)),
      (tasks) => emit(TodayInspectionLoaded(tasks: tasks)),
    );
  }

  Future<void> _onRefreshed(
    TodayInspectionRefreshed event,
    Emitter<TodayInspectionState> emit,
  ) async {
    if (state is TodayInspectionLoaded) {
      emit((state as TodayInspectionLoaded).copyWith(isRefreshing: true));
    }
    final result = await _getTodayInspectionsUseCase(NoParams());
    result.fold(
      (failure) => emit(TodayInspectionError(message: failure.message)),
      (tasks) => emit(TodayInspectionLoaded(tasks: tasks)),
    );
  }
}
