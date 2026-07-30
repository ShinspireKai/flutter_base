import 'package:flutter/material.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/maintenance_task_entity.dart';

/// PendingRecheckCard — hiển thị một nhiệm vụ trong danh sách「待我複檢」
class PendingRecheckCard extends StatelessWidget {
  final MaintenanceTaskEntity task;

  const PendingRecheckCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final priorityColor = _priorityColorFor(task.priority);
    final completedAt = task.completedAt;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: ColorName.borderOutline, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
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
                  color: ColorName.colorTextOrgan.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Text(
                  l10n.maintenanceStatusPendingRecheck,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorName.colorTextOrgan,
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
                  style: TextStyle(fontSize: 16, color: ColorName.colorTextGrey),
                ),
              ),
              if (completedAt != null)
                Text(
                  l10n.completedAtSuffix(_formatDateTime(completedAt)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, color: ColorName.colorTextGrey),
                ),
            ],
          ),
        ],
      ),
    );
  }

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

  String _formatDateTime(DateTime date) {
    final hh = date.hour.toString().padLeft(2, '0');
    final mm = date.minute.toString().padLeft(2, '0');
    return '${date.month}/${date.day} $hh:$mm';
  }
}
