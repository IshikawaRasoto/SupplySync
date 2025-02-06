class Log {
  final DateTime timestamp;
  final String level;
  final String source;
  final String message;

  const Log({
    required this.timestamp,
    required this.level,
    required this.source,
    required this.message,
  });
}
