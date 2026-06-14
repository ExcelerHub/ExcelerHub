import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final bool compact;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: compact ? 8 : 10),
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: compact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusCard),
        border: Border.all(
          color: task.isCompleted
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: task.isCompleted ? AppColors.success : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted
                      ? AppColors.success
                      : AppColors.textLight,
                  width: 1.5,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              maxLines: compact ? 1 : 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 13 : 14,
                fontWeight: FontWeight.w500,
                color: task.isCompleted
                    ? AppColors.textLight
                    : AppColors.textPrimary,
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
