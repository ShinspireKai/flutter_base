import 'package:flutter/material.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/inspection_task_entity.dart';

/// InspectionTaskCard — hiển thị một hạng mục巡檢 trong danh sách「今日巡檢」
class InspectionTaskCard extends StatelessWidget {
  final InspectionTaskEntity task;

  const InspectionTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(context, task.status);
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
                    Text(
                      task.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: style.color.withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        style.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: style.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // TODO: '異常 1' và '0/10' là dữ liệu mẫu — cần lấy số liệu thực từ task.
                      '📍${task.location} · ${_formatTime(task.scheduledTime)} · ${AppLocalizations.of(context)!.abnormalLabel} 1',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorName.colorTextGrey,
                      ),
                    ),
                    Text(
                      '0/10',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
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

  String _formatTime(DateTime time) {
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  _StatusStyle _styleFor(BuildContext context, InspectionTaskStatus status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case InspectionTaskStatus.completed:
        return _StatusStyle(
          label: l10n.statusCompleted,
          icon: Icons.check_circle_outline,
          color: Colors.green.shade600,
        );
      case InspectionTaskStatus.overdue:
        return _StatusStyle(
          label: l10n.statusInProgress,
          icon: Icons.warning_amber_rounded,
          color: ColorName.bluePrimary,
        );
      case InspectionTaskStatus.pending:
        return _StatusStyle(
          label: l10n.statusNotStarted,
          icon: Icons.schedule_rounded,
          color: ColorName.colorTextGrey,
        );
    }
  }
}

class _StatusStyle {
  final String label;
  final IconData icon;
  final Color color;

  const _StatusStyle({
    required this.label,
    required this.icon,
    required this.color,
  });
}
