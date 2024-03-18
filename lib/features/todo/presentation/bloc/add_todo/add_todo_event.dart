part of 'add_todo_bloc.dart';

sealed class AddTodoEvent extends Equatable {
  const AddTodoEvent();

  @override
  List<Object> get props => [];
}

final class EditTodoTitleChanged extends AddTodoEvent {
  const EditTodoTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

final class EditTodoDeadlineChanged extends AddTodoEvent {
  const EditTodoDeadlineChanged(this.deadline);

  final DateTime deadline;

  @override
  List<Object> get props => [deadline];
}

final class EditSelectedCategory extends AddTodoEvent {
  const EditSelectedCategory(this.category);

  final String category;

  @override
  List<Object> get props => [category];
}

final class EditTodoSubmitted extends AddTodoEvent {
  const EditTodoSubmitted();
}
