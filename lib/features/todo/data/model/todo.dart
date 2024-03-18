import 'package:uuid/uuid.dart';

class Todo {
  Todo({
    required this.title,
    String? id,
    this.deadline,
    this.isCompleted = false,
    this.category,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final DateTime? deadline;
  final String? category;
  final bool isCompleted;

  Todo copyWith({
    String? id,
    String? title,
    DateTime? deadline,
    bool? isCompleted,
    String? category,
  }) {
    return Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        deadline: deadline ?? this.deadline,
        isCompleted: isCompleted ?? this.isCompleted,
        category: category ?? this.category);
  }

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'] as String?,
        title: json['title'] as String,
        deadline: json['deadline'] != null
            ? DateTime.tryParse(json['deadline'])
            : null,
        isCompleted: json['isCompleted'] as bool? ?? false,
        category: json['category'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'deadline': deadline?.toString(),
        'isCompleted': isCompleted,
        'category': category,
      };
}
