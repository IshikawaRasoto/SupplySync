import '../../domain/entities/log.dart';

class LogModel extends Log {
  const LogModel({
    required super.timestamp,
    required super.level,
    required super.source,
    required super.message,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    // Parse the date string in the format "DD/MM/YY HH:mm:ss"
    final dateStr = json['date'] as String;
    final parts = dateStr.split(' ');
    final dateParts = parts[0].split('/');
    final timeParts = parts[1].split(':');

    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = 2000 + int.parse(dateParts[2]); // Convert YY to YYYY
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final second = int.parse(timeParts[2]);

    final timestamp = DateTime(year, month, day, hour, minute, second);

    return LogModel(
      timestamp: timestamp,
      level: json['level'] as String,
      source: json['source'] as String,
      message: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': '${timestamp.day.toString().padLeft(2, '0')}/'
          '${timestamp.month.toString().padLeft(2, '0')}/'
          '${(timestamp.year % 100).toString().padLeft(2, '0')} '
          '${timestamp.hour.toString().padLeft(2, '0')}:'
          '${timestamp.minute.toString().padLeft(2, '0')}:'
          '${timestamp.second.toString().padLeft(2, '0')}',
      'level': level,
      'source': source,
      'body': message,
    };
  }
}
