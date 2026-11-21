import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  const AppNotification({
    this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.receivedAt,
  });
  final String? id;
  final String title;
  final String body;

  /// `call`, `reminder`, `confirmation` o `info`.
  final String type;
  final DateTime receivedAt;

  @override
  List<Object?> get props => [id, title, body, type, receivedAt];
}
