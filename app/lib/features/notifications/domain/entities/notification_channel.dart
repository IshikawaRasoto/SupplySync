enum NotificationChannel {
  orders('orders', 'Orders', 'Notifications about orders'),
  chat('chat', 'Chat', 'Message notifications'),
  system('system', 'System', 'System notifications');

  final String id;
  final String name;
  final String description;

  const NotificationChannel(this.id, this.name, this.description);
}
