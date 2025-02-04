import 'package:flutter/material.dart';
import '../../../../../core/common/entities/log.dart';
import 'package:intl/intl.dart';

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
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 16),
          _buildSourceBadge(log.source),
        ],
      ),
      subtitle: Text(log.message),
    );
  }

  Widget _buildLevelBadge(String level) {
    Color color;
    switch (level.toUpperCase()) {
      case 'ERROR':
        color = Colors.red;
      case 'WARNING':
        color = Colors.orange;
      case 'INFO':
        color = Colors.blue;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
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
        color: Colors.grey.withOpacity(0.2),
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
