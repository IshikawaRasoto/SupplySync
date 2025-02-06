enum NotificationChannel {
  inventory('inventory', 'Inventory', 'Stock updates and inventory alerts'),
  cartOperation(
      'cart_ops', 'Cart Operations', 'Drone cart status and operation updates'),
  shipping('shipping', 'Shipping', 'Dock and shipping related notifications'),
  maintenance(
      'maintenance', 'Maintenance', 'System and equipment maintenance alerts'),
  userActions('user_actions', 'User Actions',
      'User authentication and permission updates'),
  system('system', 'System', 'Critical system notifications');

  final String id;
  final String name;
  final String description;

  const NotificationChannel(this.id, this.name, this.description);
}
