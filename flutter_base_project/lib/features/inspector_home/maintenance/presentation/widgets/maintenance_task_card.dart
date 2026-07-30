import 'package:flutter/material.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/maintenance_task_entity.dart';

/// MaintenanceTaskCard — hiển thị một nhiệm vụ 維修 trong danh sách「我的維修任務」
class MaintenanceTaskCard extends StatelessWidget {
  final MaintenanceTaskEntity task;

  const MaintenanceTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusStyle = _statusStyleFor(l10n, task);
    final priorityColor = _priorityColorFor(task.priority);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: ColorName.borderOutline, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$priorityColor ${task.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusStyle.color.withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Text(
                        statusStyle.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: statusStyle.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorName.colorTextGrey,
                        ),
                      ),
                    ),
                    Text(
                      l10n.assignedDateSuffix(_formatDate(task.assignedDate)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorName.colorTextGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.month}/${date.day}';

  String _priorityColorFor(MaintenanceTaskPriority priority) {
    switch (priority) {
      case MaintenanceTaskPriority.high:
        return '🔴';
      case MaintenanceTaskPriority.medium:
        return '🟡';
      case MaintenanceTaskPriority.low:
        return '⚪';
    }
  }

  _StatusStyle _statusStyleFor(
    AppLocalizations l10n,
    MaintenanceTaskEntity task,
  ) {
    switch (task.status) {
      case MaintenanceTaskStatus.inProgress:
        return _StatusStyle(
          label: task.reworkRound > 0
              ? l10n.maintenanceStatusReworking
              : l10n.maintenanceStatusInProgress,
          color: ColorName.bluePrimary,
        );
      case MaintenanceTaskStatus.pending:
        return _StatusStyle(
          label: l10n.maintenanceStatusPending,
          color: ColorName.colorTextGrey,
        );
      case MaintenanceTaskStatus.pendingRecheck:
        return _StatusStyle(
          label: l10n.maintenanceStatusPendingRecheck,
          color: ColorName.colorTextOrgan,
        );
      case MaintenanceTaskStatus.completed:
        return _StatusStyle(
          label: l10n.maintenanceStatusCompleted,
          color: Colors.green.shade600,
        );
    }
  }
}

class _StatusStyle {
  final String label;
  final Color color;

  const _StatusStyle({required this.label, required this.color});
}
