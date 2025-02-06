import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../domain/entities/log.dart';

class LogEntry extends StatelessWidget {
  final Log log;

  const LogEntry({required this.log, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          _buildLevelBadge(log.level),
          const SizedBox(width: 8),
          Text(
            DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp),
            style: const TextStyle(color: AppColors.grey),
          ),
          const SizedBox(width: 16),
          _buildSourceBadge(log.source),
        ],
      ),
      subtitle: Text(log.message),
    );
  }

  Widget _buildLevelBadge(String level) {
    late Color color;
    switch (level.toUpperCase()) {
      case 'ERROR':
        color = AppColors.red;
      case 'WARNING':
        color = AppColors.orange;
      case 'INFO':
        color = AppColors.blue;
      default:
        color = AppColors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getColorWithOpacity(color, 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        level,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSourceBadge(String source) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getColorWithOpacity(AppColors.grey, 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        source,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
