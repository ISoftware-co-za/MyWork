class Notification {
  final String text;
  const Notification(this.text);
}

class NotificationError extends Notification {
  const NotificationError(super.text);
}
