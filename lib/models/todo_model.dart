import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String status; // 'pending', 'in_progress', 'completed'
  final String priority; // 'low', 'medium', 'high'
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Buat instance dari JSON (response backend).
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      priority: json['priority'] as String,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert ke JSON (misalnya untuk kirim ke API).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  TodoModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    description,
    status,
    priority,
    dueDate,
    createdAt,
    updatedAt,
  ];
}
