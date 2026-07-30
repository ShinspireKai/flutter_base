import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_maintenance_tasks_usecase.dart';
import 'maintenance_task_event.dart';
import 'maintenance_task_state.dart';

/// MaintenanceTaskBloc — quản lý state trang「我的維修任務」của 維修人員 (Technician)
///
/// Events → States:
///   MaintenanceTaskLoadTasks → MaintenanceTaskLoading → MaintenanceTaskLoaded | MaintenanceTaskError
///   MaintenanceTaskRefreshed → MaintenanceTaskLoaded(isRefreshing: true) → MaintenanceTaskLoaded
class MaintenanceTaskBloc
    extends Bloc<MaintenanceTaskEvent, MaintenanceTaskState> {
  final GetMaintenanceTasksUseCase _getMaintenanceTasksUseCase;

  MaintenanceTaskBloc({
    required GetMaintenanceTasksUseCase getMaintenanceTasksUseCase,
  })  : _getMaintenanceTasksUseCase = getMaintenanceTasksUseCase,
        super(const MaintenanceTaskInitial()) {
    on<MaintenanceTaskLoadTasks>(_onLoadTasks);
    on<MaintenanceTaskRefreshed>(_onRefreshed);
  }

  Future<void> _onLoadTasks(
    MaintenanceTaskLoadTasks event,
    Emitter<MaintenanceTaskState> emit,
  ) async {
    emit(const MaintenanceTaskLoading());
    final result = await _getMaintenanceTasksUseCase(NoParams());
    result.fold(
      (failure) => emit(MaintenanceTaskError(message: failure.message)),
      (tasks) => emit(MaintenanceTaskLoaded(tasks: tasks)),
    );
  }

  Future<void> _onRefreshed(
    MaintenanceTaskRefreshed event,
    Emitter<MaintenanceTaskState> emit,
  ) async {
    if (state is MaintenanceTaskLoaded) {
      emit((state as MaintenanceTaskLoaded).copyWith(isRefreshing: true));
    }
    final result = await _getMaintenanceTasksUseCase(NoParams());
    result.fold(
      (failure) => emit(MaintenanceTaskError(message: failure.message)),
      (tasks) => emit(MaintenanceTaskLoaded(tasks: tasks)),
    );
  }
}
