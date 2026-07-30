import 'package:flutter/material.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';

import '../../../../../core/l10n/app_localizations.dart';

/// ChecklistProgressBar — thanh tiến độ hoàn thành checklist
/// Ví dụ: ████████░░ 8/10 已完成
class ChecklistProgressBar extends StatelessWidget {
  final int completedCount;
  final int totalCount;

  const ChecklistProgressBar({
    super.key,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: ColorName.borderOutline,
            valueColor: AlwaysStoppedAnimation(Colors.green.shade600),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppLocalizations.of(context)!.completedCountLabel(completedCount, totalCount),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ColorName.colorTextGrey,
          ),
        ),
      ],
    );
  }
}
